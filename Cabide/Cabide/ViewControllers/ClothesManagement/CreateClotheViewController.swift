//
//  CreateClotheViewController.swift
//  Cabide
//
//  Created by Luana Tais Thomas on 03/08/23.
//

import UIKit
import PhotosUI

class CreateClotheViewController: UIViewController, PHPickerViewControllerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    let viewModel = ClotheViewModel()
    
    @IBOutlet weak var clotheImage: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
        //        self.preferredContentSize = CGSize(width: 300, height: 200)
//        // Defina o estilo de apresentação como custom
//        self.modalPresentationStyle = .custom
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openCameraPressed(_ sender: Any) {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = .camera
        imagePickerVC.allowsEditing = true
        imagePickerVC.delegate = self
        present(imagePickerVC, animated: true)
    }
    
    @IBAction func openGaleryPressed(_ sender: Any) {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        let filter = PHPickerFilter.any(of: [.images])
        
        configuration.filter = filter
        
        let picker = PHPickerViewController(configuration: configuration)
        
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        viewModel.createClothe(image: clotheImage.image ?? UIImage())
//        dismiss(animated: true, completion: nil)
        self.presentingViewController?.dismiss(animated: true)
    }
    

    
}

extension CreateClotheViewController {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: .none)
        
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                guard let image = reading as? UIImage, error == nil else { return }
                
                DispatchQueue.global(qos: .userInitiated).async {
                    if let imageWithoutBG = image.removeBackground(),
                       let croppedImage = imageWithoutBG.croppedToOpaque() {
                        DispatchQueue.main.async {
                            self.clotheImage.image = croppedImage
                        }
                    }
                }
                
            }
        }
        
        saveButton.isEnabled = true
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
//        DispatchQueue.main.async {
//            self.clotheImage.image = image.removeBackground()
//        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let imageWithoutBG = image.removeBackground(),
               let croppedImage = imageWithoutBG.croppedToOpaque() {
                DispatchQueue.main.async {
                    self.clotheImage.image = croppedImage
                }
            }
        }
        
        saveButton.isEnabled = true
    }
}
