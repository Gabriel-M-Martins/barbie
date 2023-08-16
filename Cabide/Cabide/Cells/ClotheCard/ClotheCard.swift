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
    @IBOutlet weak var deleteIcon: UIImageView!
    
    var isDeleteIconVisible: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        deleteIcon.isHidden = true
        
        background.layer.shadowColor = UIColor.lightGray.cgColor
        background.layer.shadowOffset = CGSize(width: 0, height: 1)
        background.layer.shadowOpacity = 0.5
        background.layer.shadowRadius = 2.0
        background.layer.cornerRadius = 8
        background.clipsToBounds = false
    }

    func select() {
        background.layer.borderColor = UIColor(named: "lilac")?.cgColor
        background.layer.borderWidth = 2
    }
    
    func deselect() {
        background.layer.borderColor = .none
        background.layer.borderWidth = 0
    }
    
    func showDeleteIcon() {
        deleteIcon.isHidden = false
        isDeleteIconVisible = true
    }
    
    func hideDeleteIcon() {
        deleteIcon.isHidden = true
        isDeleteIconVisible = false
    }
}

protocol ClotheCardDelegate: AnyObject {
    func confirmDeleteForItem(at indexPath: IndexPath)
}
