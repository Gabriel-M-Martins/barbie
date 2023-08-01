//
//  OpenedCanvaViewController.swift
//  Cabide
//
//  Created by Gabriel Medeiros Martins on 31/07/23.
//

import UIKit

class OpenedCanvaViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    
    var canva: Canva?
    var viewModel: OpenedCanvaViewModel = OpenedCanvaViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let canva = self.canva else { return }
        nameLabel.text = canva.name
        descriptionLabel.text = canva.desc
        
        let imageData = canva.thumbnail ?? Data()
        thumbnail.image = UIImage(data: imageData)
    }
    
    @IBAction func deleteCanva(_ sender: Any) {
        guard let canva = self.canva else { return }
        viewModel.service.delete(canva)
    }
    
}
