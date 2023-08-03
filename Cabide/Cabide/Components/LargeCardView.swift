//
//  LargeCardView.swift
//  Cabide
//
//  Created by Eduardo Filot Brum on 01/08/23.
//

import UIKit

class LargeCardView: UIView {
    static  let identifier = "LargeCardView"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: LargeCardView.identifier, bundle: nil)
        
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {fatalError("Unable to convert nib")}
        
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let gradient = setGradientBackground()
        gradient.frame = view.bounds
        
        view.dropShadow()
        view.layer.addSublayer(gradient)
        
        addSubview(view)
    }
    
    func setGradientBackground() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [UIColor.white.withAlphaComponent(0.0).cgColor, UIColor.gray.withAlphaComponent(0.2).cgColor]
        gradientLayer.locations = [0.7, 1.0]
        gradientLayer.cornerRadius = 8
        
        return gradientLayer
    }
}

extension UIView {
    func dropShadow() {
        layer.cornerRadius = 4
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 1, height: -3)
        
        layer.shadowOffset = CGSize(width: -1, height: -3)
        layer.shadowRadius = 4
    }
}
