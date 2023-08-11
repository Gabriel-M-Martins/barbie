//
//  FilterCollectionViewCell.swift
//  Cabide
//
//  Created by Gabriel Medeiros Martins on 10/08/23.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var xImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    var filterName: String?
    var enabled: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        name.text = filterName
//        let width = name.frame.width + xImage.frame.width + 16
//        self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: width, height: self.frame.height))
        
//        mainView.translatesAutoresizingMaskIntoConstraints = false
//        mainView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width - 40).isActive = true
        background.translatesAutoresizingMaskIntoConstraints = false
        background.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        
        background.layer.borderWidth = 1
        background.layer.cornerRadius = 8
        changeBackgroundAppearence()
    }
    
    func toggle(_ enabled: Bool) {
        self.enabled = enabled
        changeBackgroundAppearence()
    }
    
    private func changeBackgroundAppearence() {
        if enabled {
            background.backgroundColor = UIColor(named: "lilac")
            background.layer.borderColor = UIColor.clear.cgColor
            name.textColor = .white
            xImage.tintColor = .white
            xImage.image = UIImage(systemName: "xmark")
        } else {
            background.backgroundColor = UIColor.clear
            background.layer.borderColor = UIColor(named: "lilac")?.cgColor
            name.textColor = .black
            xImage.tintColor = .black
            xImage.image = UIImage(systemName: "plus")
        }
    }

}
