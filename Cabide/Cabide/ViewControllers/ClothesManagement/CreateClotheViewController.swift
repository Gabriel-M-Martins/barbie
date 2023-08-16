//
//  CreateClotheViewController.swift
//  Cabide
//
//  Created by Luana Tais Thomas on 03/08/23.
//

import UIKit
import PhotosUI

class CreateClotheViewController: UIViewController, PHPickerViewControllerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    let model = ClotheViewModel()
    weak var delegate: CreateClotheDelegate?

    @IBOutlet weak var clotheImage: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var tagsCollection: UICollectionView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    let filterCell = UINib(nibName: "FilterCollectionViewCell", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
        loading.isHidden = true
        
        tagsCollection.delegate = self
        tagsCollection.dataSource = self
        tagsCollection.register(filterCell, forCellWithReuseIdentifier: "FilterCell")
        
        clotheImage.layer.shadowColor = UIColor.lightGray.cgColor
        clotheImage.layer.shadowOffset = CGSize(width: 0, height: 1)
        clotheImage.layer.shadowOpacity = 0.8
        clotheImage.layer.shadowRadius = 2.0
        clotheImage.clipsToBounds = false
        
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 10.0
        layout.minimumInteritemSpacing = 10.0
        
        tagsCollection.collectionViewLayout = layout
        if let filtersCollectionViewLayout = tagsCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            filtersCollectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        
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
        model.createClothe(image: clotheImage.image ?? UIImage())
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


extension CreateClotheViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model.tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as? FilterCollectionViewCell
        
        let tag = model.tags[indexPath.row]
        
        cell?.name.text = tag.name
        cell?.toggle(model.selectedTags.contains(tag))
        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tag = model.tags[indexPath.row]
        model.toggleTag(tag)
        
        DispatchQueue.main.async { [weak self] in
            self?.tagsCollection.reloadItems(at: [indexPath])
        }
    }
}
