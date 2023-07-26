//
//  CanvaViewController.swift
//  Cabide
//
//  Created by Gabriel Medeiros Martins on 24/07/23.
//

import UIKit

class CanvaViewController: UIViewController {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var placeholderImage: UIImageView!
    
    private var objects: [UIView] = []
    private var activeObject: UIView?
    private var touch: UITouch?
    
    private var tshirt = UIImage(named: "tshirt")
    
    private var viewModel = OpenedCanvaViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.
        
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
        placeholderImage.isUserInteractionEnabled = true
    }
}

extension CanvaViewController : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}

// MARK: - Gestures
extension CanvaViewController {
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
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
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
    
    @objc func handleRotate(_ gesture: UIRotationGestureRecognizer) {
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
    
    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
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
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        guard let object = activeObject else { return }
        self.container.bringSubviewToFront(object)
    }
}


// MARK: - ViewModel
class OpenedCanvaViewModel {
    /// ID : (Transform, Frame)
    /// Stores this canva' "session" in a dictionary to be later saved on CoreData.
    private var canvaStore: [UUID : (transform: CGAffineTransform, frame: CGRect)] = [:]
    
    /**
     Adds or updates an image to the store.
     - Parameters:
        - id: the image's UUID.
     */
    func putImage(id: UUID, _ transform: CGAffineTransform, _ frame: CGRect) {
        canvaStore[id] = (transform, frame)
    }
    
    /**
     Removes an image from the store.
     - Parameters:
        - id: the image's UUID.
    */
    func removeImage(id: UUID) {
        canvaStore.removeValue(forKey: id)
    }
    
    /**
     Saves the store into the shared CoreData context. This isn't yet implemented as the canva's entity doesn't currently exists, so all the canva's info used when creating one are missing from the method.
     */
    func save() -> Bool {
        return false
    }
}
