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

    @IBOutlet weak var labelName: UILabel!

    @IBOutlet weak var deleteIcon: UIImageView!
    
    weak var delegate: LargeCardDelegate?
    var isDeleteIconVisible: Bool = false

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        deleteIcon.isHidden = true
        
        background.layer.shadowColor = UIColor.black.cgColor
        background.layer.shadowOffset = CGSize(width: 2, height: 1)
        background.layer.shadowOpacity = 0.1
        background.layer.cornerRadius = 8
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

protocol LargeCardDelegate: AnyObject {
    func confirmDeleteForItem(at indexPath: IndexPath)
}
