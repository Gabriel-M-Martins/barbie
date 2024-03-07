//
//  TesteViewController.swift
//  Cabide
//
//  Created by Gabriel Medeiros Martins on 02/08/23.
//

import UIKit

class CanvaViewController: UIViewController, UIAdaptivePresentationControllerDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var filtersCollection: UICollectionView!
    @IBOutlet weak var clothesCollection: UICollectionView!
    @IBOutlet weak var modal: UIView!
    @IBOutlet weak var canva: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    let clotheCard = UINib(nibName: "ClotheCard", bundle: nil)
    let filterCell = UINib(nibName: "FilterCollectionViewCell", bundle: nil)
    
    var model: CanvaViewModel = CanvaViewModel()
    
    var mainButton: UIBarButtonItem = UIBarButtonItem()
    var cancelButton: UIBarButtonItem = UIBarButtonItem()
    
    var objects: [(view: UIView, clothe: Clothe)] = []
    
    var dismissDelegate: CanvaDismissDelegate? = nil
    
    private var activeObject: UIView?
    private var touch: UITouch?
    private var nameFieldUnderline: CALayer?
    
    let tintColor = UIColor(named: "Roxo")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.canvaDelegate = self
        model.canvaNameDelegate = self
        
        nameFieldUnderline = CALayer()
        nameFieldUnderline!.frame = CGRectMake(0.0, nameField.frame.height - 8, nameField.frame.width, 1.0)
        nameFieldUnderline!.backgroundColor = UIColor.tertiaryLabel.cgColor
        
        nameField.borderStyle = UITextField.BorderStyle.none
        nameField.layer.addSublayer(nameFieldUnderline!)
        
        clothesCollection.delegate = self
        clothesCollection.dataSource = self
        clothesCollection.register(clotheCard, forCellWithReuseIdentifier: "clotheCard")
        
        filtersCollection.delegate = self
        filtersCollection.dataSource = self
        filtersCollection.register(filterCell, forCellWithReuseIdentifier: "FilterCell")
        if let filtersCollectionViewLayout = filtersCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            filtersCollectionViewLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
        
        modal.layer.shadowColor = UIColor.lightGray.cgColor
        modal.layer.shadowOffset = CGSize(width: 0, height: -1.5)
        modal.layer.shadowOpacity = 0.5
        modal.layer.shadowRadius = 2.0
        modal.clipsToBounds = false
        
        mainButton = UIBarButtonItem(image: model.mainButtonImage, style: .plain, target: self, action: #selector(self.mainButtonPressed))
        mainButton.tintColor = tintColor
        
        cancelButton = UIBarButtonItem(image: model.cancelButtonImage, style: .plain, target: self, action: #selector(self.cancelButtonPressed))
        cancelButton.tintColor = tintColor

        if model.loadedFromCanva {
            model.load()
        }
        setupState()
        
        self.tabBarController?.tabBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.tabBarController?.tabBar.layer.shadowOffset = CGSize(width: 0, height: -1.5)
        self.tabBarController?.tabBar.layer.shadowOpacity = 0.3
        self.tabBarController?.tabBar.layer.shadowRadius = 2.0
        self.tabBarController?.tabBar.clipsToBounds = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissDelegate?.didDismissCanva()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        model.clotheService.fetch()
        DispatchQueue.main.async {
            self.clothesCollection.reloadData()
        }
    }
    
    @objc private func mainButtonPressed() {
        model.mainButtonPressed()
    }
    
    @objc private func cancelButtonPressed() {
        model.cancelButtonPressed()
    }
}

// MARK: - model delegate
extension CanvaViewController : CanvaDelegate, CanvaNameDelegate {
    var canvaName: String? { nameField.hasText ? nameField.text : nil }
    var thumbnail: UIImage {
        canva.asImage()
    }
    
    func reset() {
        nameField.text = nil
        for object in objects {
            object.view.removeFromSuperview()
        }
        objects = []
        setupState()
    }
    
    func loadFromCanva(clothes: [(clothe: Clothe, position: ClotheAtCanvaPosition)]) {
        self.objects.forEach { (view: UIView, _: Clothe) in
            view.removeFromSuperview()
        }
        self.objects = []
        for (clothe, position) in clothes {
            let image = UIImage(data: clothe.image ?? Data())
            
            let newObject = UIImageView(frame: .zero)
            newObject.transform = position.transform
            
            self.canva.addSubview(newObject)
            objects.append((newObject, clothe))
            
            newObject.contentMode = .scaleAspectFit
            newObject.image = image
            
            newObject.frame = position.position
            newObject.center = .init(x: position.position.midX, y: position.position.midY)
        }
        self.setupState()
    }
    
    func segueToSaveModal() {
         performSegue(withIdentifier: "toCreateCanva", sender: model)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCreateCanva" {
            guard let vc = segue.destination as? CreateCanvaViewController else { return }
            
            vc.model = model
            vc.presentationController?.delegate = self
        }
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.take(cancelled: true)
    }
    
    func setupState() {
        nameField.isHidden = model.hideNameTextField
        nameLabel.isHidden = model.hideNameLabel
        
        if model.loadedFromCanva {
            nameField.text = model.canvaName
        } else {
            nameField.placeholder = model.canvaName
        }
        nameLabel.text = model.canvaName
        
        mainButton.image = model.mainButtonImage
        
        switch model.state {
        case .visualization:
            canva.gestureRecognizers = []
            for object in objects {
                object.view.gestureRecognizers = []
            }
            
            navigationItem.setRightBarButtonItems([mainButton], animated: true)
        case .editing:
            let rotate = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate))
            rotate.cancelsTouchesInView = false
            rotate.delegate = self
            canva.addGestureRecognizer(rotate)

            let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
            pinch.cancelsTouchesInView = false
            pinch.delegate = self
            canva.addGestureRecognizer(pinch)
            
            for object in objects {
                self.addGestureToView(object.view)
            }
            
            navigationItem.setRightBarButtonItems([mainButton, cancelButton], animated: true)
            
            model.clotheService.fetch()
            DispatchQueue.main.async {
                self.clothesCollection.reloadData()
            }
        }
    }
}

// MARK: - multi-gesture input
extension CanvaViewController : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}

// MARK: - gestures
extension CanvaViewController {
    private func bringToFront(_ object: UIView) {
        canva.bringSubviewToFront(object)
    }
    
    private func addGestureToView(_ view: UIView) {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
        
        view.isUserInteractionEnabled = true
        view.isMultipleTouchEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let position = touch.location(in: view)
            guard let touchedView = view.hitTest(position, with: event) else { continue }
            
            if objects.contains(where: {$0.view == touchedView}) && activeObject == nil && self.touch == nil {
                activeObject = touchedView
                self.touch = touch
                bringToFront(activeObject!)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = self.touch else { return }
        if touches.contains(touch) {
            gestureEnded()
        }
    }
    
    private func gestureEnded() {
        guard let object = activeObject else { return }
        
        var containerFrame = canva.convert(canva.bounds, to: view.coordinateSpace)
        let objectFrame = object.convert(object.bounds, to: view.coordinateSpace)
        
        containerFrame.size.width = containerFrame.size.width * 0.8
        containerFrame.size.height = containerFrame.size.height * 0.8
        
        if CGRectIntersectsRect(containerFrame, objectFrame) {
            if !canva.subviews.contains(object) {
                let convertedPos = canva.convert(object.center, from: view)
                object.removeFromSuperview()
                canva.addSubview(object)
                object.center = convertedPos
            }
        } else {
            let idx = objects.firstIndex(where: { $0.view == object })!
            model.removeClotheFromCanva(objects[idx].clothe)
            objects.remove(at: idx)
            object.removeFromSuperview()
        }
        
        self.touch = nil
        self.activeObject = nil
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began, .changed:
            guard let object = activeObject else { return }
            let translation = gesture.translation(in: view)
            
            object.center = CGPoint(x: object.center.x + translation.x, y: object.center.y + translation.y)
            gesture.setTranslation(.zero, in: view)
        case .ended:
            gestureEnded()
        default:
            break
        }
    }
    
    @objc private func handleRotate(_ gesture: UIRotationGestureRecognizer) {
        switch gesture.state {
        case .began, .changed:
            guard let object = activeObject else { return }
            
            object.transform = object.transform.rotated(by: gesture.rotation)
            gesture.rotation = 0
        case .ended:
            gestureEnded()
        default:
            break
        }
    }
    
    @objc private func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .began, .changed:
            guard let object = activeObject else { return }
            
            object.transform = object.transform.scaledBy(x: gesture.scale, y: gesture.scale)
            gesture.scale = 1
        case .ended:
            gestureEnded()
        default:
            break
        }
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        guard let object = activeObject else { return }
        self.canva.bringSubviewToFront(object)
    }
}


// MARK: - Collection View
extension CanvaViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView == clothesCollection ? model.clothes.count : model.tags.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == clothesCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "clotheCard", for: indexPath) as? ClotheCard
            
            let clothe = model.clothes[indexPath.row]
            let image = UIImage(data: clothe.image ?? Data())
            
            cell?.image.image = image

            return cell ?? UICollectionViewCell()
        }
        
        if collectionView == filtersCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as? FilterCollectionViewCell
            
            let tag = model.tags[indexPath.row]
            
            cell?.name.text = tag.name
            cell?.toggle(model.selectedTags.contains(tag))
            
            return cell ?? UICollectionViewCell()
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == filtersCollection {
            let tag = model.tags[indexPath.row]
            model.toggleTag(tag)
            
            DispatchQueue.main.async { [weak self] in
                self?.filtersCollection.performBatchUpdates({
                    self?.filtersCollection.reloadSections(IndexSet(integer: 0))
                })
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.clothesCollection.performBatchUpdates({
                    self?.clothesCollection.reloadSections(IndexSet(integer: 0))
                })
            }
            
            return
        }
        
        
        if collectionView == clothesCollection {
            guard model.collectionIsUserInteractionEnabled else { return }
            
            let clothe = model.clothes[indexPath.row]
            let imageData = clothe.image ?? Data()
            let image = UIImage(data: imageData)
            
            // this should change somehow so the image is draggable instead of it justing appearing on the canva
            let newObject = UIImageView(frame: .zero)
            
            self.canva.addSubview(newObject)
            objects.append((newObject, clothe))
            
            newObject.contentMode = .scaleAspectFit
            newObject.image = image
            
            newObject.frame = .init(origin: .init(x: canva.frame.width/2, y: canva.frame.height/2), size: image?.size ?? .zero)
            newObject.center = .init(x: canva.frame.width/2, y: canva.frame.height/2)
            newObject.transform = newObject.transform.scaledBy(x: canva.frame.width/(3 * (image?.size.width ?? 1)), y: canva.frame.width/(3 * (image?.size.width ?? 1)))
            
            self.addGestureToView(newObject)
            
            return
        }
    }
}

extension CanvaViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard collectionView == clothesCollection else { return CGSize(width: 15, height: 100) }
        
        let width = (collectionView.frame.width * 0.25) - 16
        let height = (collectionView.frame.height * 0.5)  - 16
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard collectionView == clothesCollection else { return UIEdgeInsets(top: collectionView.safeAreaInsets.top, left: 12, bottom: collectionView.safeAreaInsets.bottom, right: collectionView.safeAreaInsets.right) }
        return UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

extension CanvaViewController : TakeControlDelegate {
    func take(cancelled: Bool) {
        if cancelled {
            model.canvaNameDelegate = self
        } else {
            setupState()
            model.canvaNameDelegate = self
        }
    }
}

protocol TakeControlDelegate {
    func take(cancelled: Bool)
}
