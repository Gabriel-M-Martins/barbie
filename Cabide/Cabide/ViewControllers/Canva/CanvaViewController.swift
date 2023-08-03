//
//  TesteViewController.swift
//  Cabide
//
//  Created by Gabriel Medeiros Martins on 02/08/23.
//

import UIKit

class CanvaViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var modal: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    
    let clotheCard = UINib(nibName: "ClotheCard", bundle: nil)
    
    var model: CanvaViewModel = CanvaViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deleteButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        
        collection.delegate = self
        collection.dataSource = self
        (collection.collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing = 1000
        
        collection.register(clotheCard, forCellWithReuseIdentifier: "clotheCard")
        
        modal.clipsToBounds = true
        modal.layer.cornerRadius = 16
        modal.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    
    
    @IBAction func mainButtonPressed(_ sender: Any) {
        model.buttonPressed(.main)
    }
}

// MARK: - Collection View
extension CanvaViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model.clothes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "clotheCard", for: indexPath) as? ClotheCard
        
        let clothe = model.clothes[indexPath.row]
        let image = UIImage(data: clothe.image ?? Data())
        
        cell?.image.image = image

        return cell ?? UICollectionViewCell()
    }
}

extension CanvaViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = collectionView.frame.height * 0.7
        return CGSize(width: size, height: size)
    }
}
