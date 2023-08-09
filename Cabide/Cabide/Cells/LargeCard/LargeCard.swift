//
//  LargeCard.swift
//  Cabide
//
//  Created by Eduardo Filot Brum on 03/08/23.
//

import UIKit

class LargeCard: UICollectionViewCell {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        background.layer.shadowColor = UIColor.black.cgColor
        background.layer.shadowOffset = CGSize(width: 2, height: 1)
        background.layer.shadowOpacity = 0.1
    }
}
