//
//  ViewController.swift
//  Canva
//
//  Created by Gabriel Medeiros Martins on 18/07/23.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    let objSize = 100
    
    var objects: [UIView] = []
    var activeObject: UIView?
    var firstTouch: UITouch?
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @IBOutlet weak var canvas: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        pinch.cancelsTouchesInView = false
        pinch.delegate = self
        canvas.addGestureRecognizer(pinch)
        
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate))
        rotate.cancelsTouchesInView = false
        rotate.delegate = self
        canvas.addGestureRecognizer(rotate)
    }


    @IBAction func addObject(_ sender: Any) {
        let render = UIGraphicsImageRenderer(size: CGSize(width: objSize, height: objSize))
        let img = render.image { ctx in
            let obj = CGRect(x: 0, y: 0, width: objSize, height: objSize)
            ctx.cgContext.setFillColor(UIColor.random().cgColor)
            ctx.cgContext.setLineWidth(0)
            ctx.cgContext.addRect(obj)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        let obj = UIImageView(image: img)
        obj.frame.origin = CGPoint(x: canvas.frame.midX - CGFloat(objSize/2), y: canvas.frame.midY - CGFloat(objSize/2))
        
        obj.isUserInteractionEnabled = true
        obj.isMultipleTouchEnabled = true
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        pan.cancelsTouchesInView = false
        pan.delegate = self
        obj.addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.cancelsTouchesInView = false
        obj.addGestureRecognizer(tap)
        
        objects.append(obj)
        canvas.addSubview(obj)
    }
    
    // MARK: - Gestures
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let position = touch.location(in: view)
            guard let touchedView = view.hitTest(position, with: event) else { continue }
            
            if objects.contains(touchedView) && activeObject == nil && firstTouch == nil {
                activeObject = touchedView
                firstTouch = touch
                
                canvas.bringSubviewToFront(touchedView)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch = firstTouch else { return }
        if touches.contains(firstTouch){
            self.firstTouch = nil
            self.activeObject = nil
        }
        print("cabo")
    }


    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {

        switch gesture.state {
        case .began, .changed:
            let translation = gesture.translation(in: view)
            guard let gestureView = activeObject else { return }
            gestureView.center = CGPoint(
                x: gestureView.center.x + translation.x,
                y: gestureView.center.y + translation.y
            )
            gesture.setTranslation(.zero, in: view)
        case .ended:
            self.activeObject = nil
            self.firstTouch = nil
        default:
            break
        }
    }

    @objc func handleRotate(_ gesture: UIRotationGestureRecognizer) {
        
        switch gesture.state {
        case .began, .changed:
            guard let activeObject = activeObject else { return }
            
            activeObject.transform = activeObject.transform.rotated(by: gesture.rotation)
            gesture.rotation = 0
        case .ended:
            self.activeObject = nil
            self.firstTouch = nil
        default:
            break
        }
    }

    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        
        switch gesture.state {
        case .began, .changed:
            guard let activeObject = activeObject else { return }
            
            activeObject.transform = activeObject.transform.scaledBy(
                x: gesture.scale,
                y: gesture.scale
            )
            gesture.scale = 1
        case .ended:
            self.activeObject = nil
            self.firstTouch = nil
        default:
            break
        }
    }

    @objc func handleTap(sender: UITapGestureRecognizer) {
        canvas.bringSubviewToFront(sender.view!)
    }
}

extension UIColor {
    static func random() -> UIColor {
        let allCases = [self.black, self.red, self.blue, self.green, self.cyan]
        return allCases.randomElement()!
    }
    
}
