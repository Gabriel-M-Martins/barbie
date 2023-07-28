//
//  ClotheDetailsCell.swift
//  Cabide
//
//  Created by Luana Tais Thomas on 28/07/23.
//

import UIKit

class ClotheDetailsCell: UITableViewCell {

    @IBOutlet weak var clotheImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descritionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
