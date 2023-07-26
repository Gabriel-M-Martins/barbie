//
//  CanvaViewController.swift
//  Cabide
//
//  Created by Gabriel Medeiros Martins on 24/07/23.
//

import UIKit

class OpenedCanvaViewController: UIViewController {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var placeholderImage: UIImageView!
    
    private var objects: [UIView] = []
    private var activeObject: UIView?
    private var touch: UITouch?
    
    private var tshirt = UIImage(named: "tshirt")
    
    private var viewModel = OpenedCanvaViewModel()
    
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
        
        /*
         TODO: Call the viewModel to load saved clothes into the tableView.
         Reminder: Each clothing image in the tableView should have .isUserInteractionEnabled set to true so the user can drag it into the canva.
        */
        let images = viewModel.loadImages()
        placeholderImage.isUserInteractionEnabled = true
    }
}

// MARK: - Enable multi-gesture input
extension OpenedCanvaViewController : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}

// MARK: - Gestures
/**
 1. User touches something on the view.
 2. touchesBegan recognizes it and checks if it is an clothing (object).
 3. If it is, registers as the active object.
 4. When a gesture is recognized, the handler tries to use the active object, if there isn't one, the gesture doesn't happen.
 */
extension OpenedCanvaViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let position = touch.location(in: view)
            guard var touchedView = view.hitTest(position, with: event) else { continue }
            
            if touchedView == placeholderImage {
                let newImage = UIImageView(frame: .zero)

                newImage.contentMode = .scaleAspectFit
                newImage.frame = placeholderImage.frame
                newImage.image = placeholderImage.image
                newImage.isUserInteractionEnabled = true
                
                let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
                newImage.addGestureRecognizer(pan)
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
                newImage.addGestureRecognizer(tap)
                
                self.view.addSubview(newImage)
                objects.append(newImage)
                
                touchedView = newImage
            }
            
            if objects.contains(touchedView) && activeObject == nil && self.touch == nil {
                activeObject = touchedView
                self.touch = touch
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
