//
//  CreateCollectionViewController.swift
//  Cabide
//
//  Created by Luana Tais Thomas on 08/08/23.
//

import UIKit

class CreateCollectionViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var looksLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var nameTextfield: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let clotheCard = UINib(nibName: "LargeCard", bundle: nil)
    
    var canvaModel: CanvaViewModel = CanvaViewModel()
    var collectionModel: CollectionViewModel = CollectionViewModel()
    
    var selectedsCanva: [Canva] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.isEnabled = false
        
        let customFonts = CustomFonts()
        
        titleLabel.font = customFonts.customFontTitle
        titleLabel.adjustsFontForContentSizeCategory = true
        
        nameLabel.font = customFonts.customFontLabel
        nameLabel.adjustsFontForContentSizeCategory = true
        
        looksLabel.font = customFonts.customFontLabel
        looksLabel.adjustsFontForContentSizeCategory = true
        
        button.titleLabel?.font = customFonts.customFontLabel
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        
        
        button.imageView?.layer.borderColor = UIColor(named: "green")?.cgColor
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(clotheCard, forCellWithReuseIdentifier: "largeCard")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    func updateButtonStatus () {
        button.isEnabled = nameTextfield.hasText
    }
    
    
    @IBAction func updateButton(_ sender: Any) {
        updateButtonStatus()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        collectionModel.createCollection(name: nameTextfield.text ?? "", canvas: selectedsCanva)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}



// MARK: - Collection View
extension CreateCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        canvaModel.canvas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "largeCard", for: indexPath) as? LargeCard
        
        let canva = canvaModel.canvas[indexPath.row]
        let image = UIImage(data: canva.thumbnail ?? Data())
        
        cell?.imageView.image = image
        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? LargeCard
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

extension CreateCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let columns: CGFloat = 3
        let spacing: CGFloat = 0
        let totalHorizontalSpacing: CGFloat = (columns - 1.0) * spacing
        
        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
        let itemSize = CGSize(width: itemWidth, height: itemWidth * 1.2)
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
}
