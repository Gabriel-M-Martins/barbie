//
//  TesteViewController.swift
//  Cabide
//
//  Created by Gabriel Medeiros Martins on 02/08/23.
//

import UIKit

class CanvaViewController: UIViewController {
    
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
    
    var objects: [(view: UIView, clothe: Clothe)] = []
    
    private var activeObject: UIView?
    private var touch: UITouch?
    private var nameFieldUnderline: CALayer?
    
    let tintColor = UIColor(named: "Roxo")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.delegate = self
        
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
            filtersCollectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        
        /*
         if let collectionViewLayout = myCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                     collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
                 }
         */
        
        modal.layer.shadowColor = UIColor.lightGray.cgColor
        modal.layer.shadowOffset = CGSize(width: 0, height: -1.5)
        modal.layer.shadowOpacity = 0.5
        modal.layer.shadowRadius = 2.0
        modal.clipsToBounds = false
        
        mainButton = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(self.mainButtonPressed))
        mainButton.tintColor = tintColor

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
        model.buttonPressed()
    }
}

// MARK: - multi-gesture input
extension CanvaViewController : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}

// MARK: - model delegate
extension CanvaViewController : CanvaDelegate {
    var canvaName: String? { nameField.text }
    var thumbnail: UIImage { canva.asImage() }
    
    func segueToSaveModal() {
        // call segue to save modal, pass viewmodel to modal
        // performSegue(withIdentifier: , sender: )
    }
    
    func setupState() {
        nameField.isHidden = model.hideNameTextField
        nameLabel.isHidden = model.hideNameLabel
        
        nameField.placeholder = model.canvaName
        nameLabel.text = model.canvaName
        
        mainButton.image = model.mainButtonImage
        
        switch model.state {
        case .visualization:
            canva.gestureRecognizers = []
            navigationItem.rightBarButtonItems = [mainButton]
        case .editing:
            let rotate = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate))
            rotate.cancelsTouchesInView = false
            rotate.delegate = self
            canva.addGestureRecognizer(rotate)

            let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
            pinch.cancelsTouchesInView = false
            pinch.delegate = self
            canva.addGestureRecognizer(pinch)

            navigationItem.setRightBarButtonItems([mainButton], animated: true)
        }
    }
}

// MARK: - gestures
extension CanvaViewController {
    private func bringToFront(_ object: UIView) {
        canva.bringSubviewToFront(object)
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
            objects.remove(at: objects.firstIndex(where: { $0.view == object })!)
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
            
            cell?.name.text = model.tags[indexPath.row].name
            return cell ?? UICollectionViewCell()
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView == clothesCollection else { return }
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

        newObject.frame = .init(origin: .init(x: canva.frame.width/2, y: canva.frame.height/2), size: image!.size)
        newObject.center = .init(x: canva.frame.width/2, y: canva.frame.height/2)

        newObject.isUserInteractionEnabled = true
        newObject.isMultipleTouchEnabled = true

        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        newObject.addGestureRecognizer(pan)

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        newObject.addGestureRecognizer(tap)
        
        newObject.layer.setValue(clothe, forKey: "clothe")
    }
}

extension CanvaViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard collectionView == clothesCollection else { return collectionView.contentSize }
        
        let width = (collectionView.frame.width * 0.25) - 16
        let height = (collectionView.frame.height * 0.5)  - 16
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard collectionView == clothesCollection else { return collectionView.safeAreaInsets }
        return UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
