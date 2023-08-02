//
//  TesteViewController.swift
//  Cabide
//
//  Created by Gabriel Medeiros Martins on 02/08/23.
//

import UIKit

class CanvaViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var collection: UICollectionView!
    
    let clotheCard = UINib(nibName: "ClotheCard", bundle: nil)
    
    var model: CanvaViewModel = CanvaViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.delegate = self
        collection.dataSource = self
        (collection.collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing = 1000
        
        collection.register(clotheCard, forCellWithReuseIdentifier: "clotheCard")
    }
    
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
    
    @IBAction func actionPressed(_ sender: Any) {
        model.changeState()
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

