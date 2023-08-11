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
    
    var model: CreateCanvaViewModel = CreateCanvaViewModel()
    var modelAux: CollectionViewModel = CollectionViewModel()
    
    var selectedsCollection: [Folder] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customFonts = CustomFonts()
        
        
        lookLabel.font = customFonts.customFontTitle
        lookLabel.adjustsFontForContentSizeCategory = true
        
        nameLabel.font = customFonts.customFontLabel
        nameLabel.adjustsFontForContentSizeCategory = true
        
        nameTextfield.font = customFonts.customFontLabel
        nameTextfield.adjustsFontForContentSizeCategory = true
        
        collectionsLabel.font = customFonts.customFontLabel
        collectionsLabel.adjustsFontForContentSizeCategory = true
        
        saveButton.titleLabel?.font = customFonts.customFontLabel
        saveButton.titleLabel?.adjustsFontForContentSizeCategory = true
        
        //collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
    }
    
    
    
}

extension CreateCanvaViewController: UICollectionViewDelegate, UICollectionViewDataSource  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
//    func collectionView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "collectionNameCell", for: indexPath)
//
//        cell.textLabel?.text = model.collections[indexPath.row].name
//        cell.selectionStyle = .none
//
//        return cell
//    }
//
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let cell = tableView.cellForRow(at: indexPath) {
//            let collection = model.collections[indexPath.row]
//
//            if selectedsCollection.contains(collection) {
//                cell.imageView?.tintColor = UIColor.gray
//                selectedsCollection.remove(at: selectedsCollection.firstIndex(of: collection) ?? 0)
//            } else {
//                cell.imageView?.tintColor = UIColor(named: "lilac") ?? UIColor.green
//                selectedsCollection.append(collection)
//            }
//        }
//
//    }
        
}
