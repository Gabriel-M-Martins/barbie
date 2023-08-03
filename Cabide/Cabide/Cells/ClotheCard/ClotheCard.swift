//
//  ClotheCard.swift
//  Cabide
//
//  Created by Gabriel Medeiros Martins on 02/08/23.
//

import UIKit

class ClotheCard: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var background: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        image.layer.cornerRadius = 10
        background.layer.cornerRadius = 10
        
        background.layer.shadowColor = UIColor.lightGray.cgColor
        background.layer.shadowOffset = CGSize(width: 0, height: 1)
        background.layer.shadowOpacity = 0.8
        background.layer.shadowRadius = 1.0
        background.clipsToBounds = false
    }

}
