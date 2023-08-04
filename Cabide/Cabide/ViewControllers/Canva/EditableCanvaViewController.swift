//
//  CanvaViewController.swift
//  Cabide
//
//  Created by Gabriel Medeiros Martins on 24/07/23.
//

import UIKit

class EditableCanvaViewController: UIViewController {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var carousel: UITableView!
    
    private var objects: [UIView] = []
    private var activeObject: UIView?
    private var touch: UITouch?
    
    private var viewModel = EditableCanvaViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Those gestures are added to the canva container instead of the object itself so that the user can click anywhere on screen (besides the object) to make the gesture.
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate))
        rotate.cancelsTouchesInView = false
        rotate.delegate = self
        view.addGestureRecognizer(rotate)

        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        pinch.cancelsTouchesInView = false
        pinch.delegate = self
        view.addGestureRecognizer(pinch)
        
        // --------------------------------------------------------------------------------------------------------------------------------------------------------------------
        self.carousel.dataSource = self
        self.carousel.delegate = self
        
        // --------------------------------------------------------------------------------------------------------------------------------------------------------------------
        let saveButton = UIBarButtonItem(title: "Salvar", style: .plain, target: self, action: #selector(save))
        let listButton = UIBarButtonItem(title: "Listar", style: .plain, target: self, action: #selector(list))
        
        self.navigationItem.rightBarButtonItems = [saveButton, listButton]
    }
    
    @objc func list() {
        performSegue(withIdentifier: "toListCanva", sender: nil)
    }
    
    @objc func save() {
        viewModel.replaceStoreState(canva: container)
        performSegue(withIdentifier: "toSaveCanva", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSaveCanva" {
            guard let vc = segue.destination as? SaveCanvaViewController else { return }
            vc.viewModel = self.viewModel
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.clotheService.update()
        DispatchQueue.main.async {
            self.carousel.reloadData()
        }
    }
}


// MARK: - TableView Data Source
extension EditableCanvaViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.clothes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basic", for: indexPath)
        
        let clothe = viewModel.clothes[indexPath.row]
        guard let image = clothe.image else { fatalError() }
        
        cell.imageView?.image = UIImage(data: image)
        cell.imageView?.contentMode = .scaleAspectFit
        
        cell.isUserInteractionEnabled = true
        cell.userInteractionEnabledWhileDragging = true
        
        cell.textLabel?.text = clothe.name
        cell.detailTextLabel?.text = clothe.description_
        
        return cell
    }
}

// MARK: - TableView Delegate
extension EditableCanvaViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let clothe = viewModel.clothes[indexPath.row]
        guard let imageData = clothe.image else { return }
        let image = UIImage(data: imageData)
        
        // this should change somehow so the image is draggable instead of it justing appearing on the canva
        let newObject = UIImageView(frame: .zero)
        newObject.contentMode = .scaleAspectFit
        newObject.image = image
        newObject.frame.size = image!.size
        newObject.center = container.center
        newObject.isUserInteractionEnabled = true

        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        newObject.addGestureRecognizer(pan)

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        newObject.addGestureRecognizer(tap)
        
        newObject.layer.setValue(clothe, forKey: "clothe")
        
        self.container.addSubview(newObject)
        objects.append(newObject)
    }
}


// MARK: - Enable multi-gesture input
extension EditableCanvaViewController : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}

// MARK: - Gestures
extension EditableCanvaViewController {
    private func bringToFront(_ object: UIView) {
        container.bringSubviewToFront(object)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let position = touch.location(in: view)
            guard let touchedView = view.hitTest(position, with: event) else { continue }
            
            if objects.contains(touchedView) && activeObject == nil && self.touch == nil {
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
        
        var containerFrame = view.convert(container.frame, to: view)
        let objectFrame = view.convert(object.frame, to: view)
        
        containerFrame.size.width = containerFrame.size.width * 0.85
        containerFrame.size.height = containerFrame.size.height * 0.85
        
        if containerFrame.intersects(objectFrame) {
            if !container.subviews.contains(object) {
                let convertedPos = container.convert(object.center, from: view)
                object.removeFromSuperview()
                container.addSubview(object)
                object.center = convertedPos
            }
        } else {
            objects.remove(at: objects.firstIndex(of: object)!)
            object.removeFromSuperview()
        }
        
        print(container.subviews.count)
        
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
        self.container.bringSubviewToFront(object)
    }
}
