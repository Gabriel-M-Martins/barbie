//
//  OpenedSavedCanvasViewController.swift
//  Canva
//
//  Created by Gabriel Medeiros Martins on 20/07/23.
//

import UIKit

class OpenedSavedCanvasViewController: UIViewController {

    @IBOutlet weak var canvaView: UIView!
    @IBOutlet weak var canvaName: UILabel!
    
    public var canva: Canva?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let canva = canva else { return }
        let images = DataManager.shared.images(canva: canva)
        
        canvaName.text = canva.name
        
        let render = UIGraphicsImageRenderer(size: CGSize(width: objSize, height: objSize))
        let img = render.image { ctx in
            let obj = CGRect(x: 0, y: 0, width: objSize, height: objSize)
            ctx.cgContext.setFillColor(UIColor.random().cgColor)
            ctx.cgContext.setLineWidth(0)
            ctx.cgContext.addRect(obj)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        for image in images {
            let obj = UIImageView(image: img)
            
            obj.frame.origin = CGPoint(x: Double(image.x), y: Double(image.y))
            obj.frame.size = CGSize(width: CGFloat(image.width), height: CGFloat(image.height))
            
            canvaView.addSubview(obj)
        }
    }

}
