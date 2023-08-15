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
    weak var delegate: CreateClotheDelegate?

    @IBOutlet weak var clotheImage: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
        loading.isHidden = true
        
        let cancelButton = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(cancelPressed) )
        cancelButton.tintColor = UIColor(named: "Roxo") ?? UIColor.black
        navigationItem.setLeftBarButton(cancelButton, animated: true)

    }
    
    @objc func cancelPressed(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
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
        delegate?.didUpdateData()
        self.presentingViewController?.dismiss(animated: true)
    }
}

extension CreateClotheViewController {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        loading.isHidden = false
        clotheImage.image = nil
        //clotheImage.isHidden = true
        picker.dismiss(animated: true, completion: .none)
        
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                guard let image = reading as? UIImage, error == nil else { return }
                
                DispatchQueue.global(qos: .userInitiated).async {
                    if let imageWithoutBG = image.removeBackground(),
                       let croppedImage = imageWithoutBG.croppedToOpaque() {
                        DispatchQueue.main.async {
                            self.clotheImage.image = croppedImage
                            self.loading.isHidden = true
                            self.clotheImage.isHidden = false
                        }
                    }
                }
                
            }
        }
        
        saveButton.isEnabled = true
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        loading.isHidden = false
        clotheImage.image = nil
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let imageWithoutBG = image.removeBackground(),
               let croppedImage = imageWithoutBG.croppedToOpaque() {
                DispatchQueue.main.async {
                    self.clotheImage.image = croppedImage
                    self.loading.isHidden = true
                    self.clotheImage.isHidden = false
                }
            }
        }
        saveButton.isEnabled = true
    }
}

protocol CreateClotheDelegate: AnyObject {
    func didUpdateData()
}
