//
//  UpdateCollectionViewController.swift
//  Cabide
//
//  Created by Luana Tais Thomas on 15/08/23.
//

import UIKit

class UpdateCollectionViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var looksLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var nameTextfield: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate: UpdateCollectionDelegate?
    
    var folder: Folder?
    
    let clotheCard = UINib(nibName: "ClotheCard", bundle: nil)
    
    var canvaModel: CanvaViewModel = CanvaViewModel()
    var collectionModel: CollectionViewModel = CollectionViewModel()
    
    var selectedsCanva: [Canva] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedsCanva = collectionModel.getCanvasFolder(folder ?? Folder()) ?? []
        
        let customFonts = CustomFonts()
        
        titleLabel.font = customFonts.customFontTitle
        titleLabel.adjustsFontForContentSizeCategory = true
        
        nameLabel.font = customFonts.customFontLabel
        nameLabel.adjustsFontForContentSizeCategory = true
        
        looksLabel.font = customFonts.customFontLabel
        looksLabel.adjustsFontForContentSizeCategory = true
        
        nameTextfield.font = customFonts.customFontLabel
        nameTextfield.adjustsFontForContentSizeCategory = true
        nameTextfield.text = folder?.name
        
        saveButton.titleLabel?.font = customFonts.customFontLabel
        saveButton.titleLabel?.adjustsFontForContentSizeCategory = true
        
        deleteButton.titleLabel?.font = customFonts.customFontLabel
        deleteButton.titleLabel?.adjustsFontForContentSizeCategory = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(clotheCard, forCellWithReuseIdentifier: "clotheCard")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        collectionModel.updateCollection(id: folder?.id ?? UUID(), name: nameTextfield.text ?? "", canvas: selectedsCanva)
        delegate?.didUpdateData()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        collectionModel.deleteCollection(id: folder?.id ?? UUID())
        dismiss(animated: true, completion: nil)
        self.delegate?.didDeleteData()
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

// MARK: - Collection View
extension UpdateCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        canvaModel.canvas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "clotheCard", for: indexPath) as? ClotheCard
        
        let canva = canvaModel.canvas[indexPath.row]
        let image = UIImage(data: canva.thumbnail ?? Data())
        
        cell?.image.image = image
        
        if selectedsCanva.contains(canva) {
            cell?.select()
        } else {
            cell?.deselect()
        }
        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? ClotheCard
        let canva = canvaModel.canvas[indexPath.row]
        
        if selectedsCanva.contains(canva) {
            cell?.deselect()
            selectedsCanva.remove(at: selectedsCanva.firstIndex(of: canva) ?? 0)
        } else {
            cell?.select()
            selectedsCanva.append(canva)
        }
    }
    
}

extension UpdateCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 3
        let spacing: CGFloat = 8
        let totalHorizontalSpacing: CGFloat = (columns - 1.0) * spacing

        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing - 16) / columns
        let itemSize = CGSize(width: itemWidth, height: itemWidth)
        return itemSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
}

protocol UpdateCollectionDelegate: AnyObject {
    func didUpdateData()
    func didDeleteData()
}

