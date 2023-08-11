//
//  CreateCanvaViewController.swift
//  Cabide
//
//  Created by Luana Tais Thomas on 10/08/23.
//

import UIKit

class CreateCanvaViewController: UIViewController {
    
    @IBOutlet weak var lookLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var collectionsLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var model: CanvaViewModel?
    
    var selectedsCollection: [Folder] = []
    
    let filterCell = UINib(nibName: "FilterCollectionViewCell", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customFonts = CustomFonts()
        
        saveButton.isEnabled = false
        
        lookLabel.font = customFonts.customFontTitle
        lookLabel.adjustsFontForContentSizeCategory = true
        
        nameLabel.font = customFonts.customFontLabel
        nameLabel.adjustsFontForContentSizeCategory = true
        
        nameTextfield.font = customFonts.customFontLabel
        nameTextfield.adjustsFontForContentSizeCategory = true
        nameTextfield.text = model?.canvaName
        
        collectionsLabel.font = customFonts.customFontLabel
        collectionsLabel.adjustsFontForContentSizeCategory = true
        
        saveButton.titleLabel?.font = customFonts.customFontLabel
        saveButton.titleLabel?.adjustsFontForContentSizeCategory = true
        
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 10.0 
        layout.minimumInteritemSpacing = 10.0
        
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(filterCell, forCellWithReuseIdentifier: "FilterCell")
        if let filtersCollectionViewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            filtersCollectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    func updateButtonStatus () {
        saveButton.isEnabled = nameTextfield.hasText
    }
    
    @IBAction func updateButton(_ sender: Any) {
        updateButtonStatus()
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        // model.createCanva (name: nameTextfield.text ?? "", canvas: selectedsCanva)
        model?.save()
        self.presentingViewController?.dismiss(animated: true)
    }
}

// MARK: - Collection View
extension CreateCanvaViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model?.folders.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as? FilterCollectionViewCell
        
        guard let folder = model?.folders[indexPath.row] else { return UICollectionViewCell() }
        
        cell?.name.text = folder.name ?? ""
        cell?.toggle(model!.selectedFolders.contains(folder))
        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let folder = model?.folders[indexPath.row] else { return }
        
        model?.selectFolder(folder)
        DispatchQueue.main.async {
            collectionView.reloadData()
        }
    }
    
}

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        
        for layoutAttribute in attributes {
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        
        return attributes
    }
}





