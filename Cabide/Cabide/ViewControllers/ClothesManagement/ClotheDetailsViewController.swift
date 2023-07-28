//
//  ClotheDetailsViewController.swift
//  Cabide
//
//  Created by Luana Tais Thomas on 28/07/23.
//

import UIKit

class ClotheDetailsViewController: UIViewController {

    @IBOutlet weak var clotheImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var descriptionTextfield: UITextField!
    let viewModel = ClotheViewModel()
    
    var clothe: Clothe!
    
    @IBAction func updatePressed(_ sender: Any) {
        viewModel.updateClothe(id: clothe.id ?? UUID(), name: nameTextfield.text ?? "", description: descriptionTextfield.text ?? "", image: clotheImage.image)
        
    }
    
    @IBAction func removePressed(_ sender: Any) {
        viewModel.deleteClothe(id: clothe.id ?? UUID())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clotheImage.image = viewModel.returnImage(id: clothe.id)
        nameLabel.text = clothe.name
        descriptionLabel.text = clothe.description_
        nameTextfield.text = clothe.name
        descriptionTextfield.text = clothe.description_
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    


}
