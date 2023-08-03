//
//  CollectionViewController.swift
//  Cabide
//
//  Created by Eduardo Filot Brum on 01/08/23.
//

import UIKit

class CollectionsViewController: UIViewController {

    @IBOutlet weak var collectionViewRecents: UICollectionView!
    
    let largeCard = UINib(nibName: "LargeCard", bundle: nil)
    
    //TODO: Change viewmodel
    var model: CanvaViewModel = CanvaViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewRecents.delegate = self
        collectionViewRecents.dataSource = self
        collectionViewRecents.register(largeCard, forCellWithReuseIdentifier: "largeCard")
    }

}

// MARK: - Collection View
extension CollectionsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model.clothes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "largeCard", for: indexPath) as? LargeCard
        
        let clothe = model.clothes[indexPath.row]
        let image = UIImage(data: clothe.image ?? Data())
        
        cell?.imageView.image = image

        return cell ?? UICollectionViewCell()
    }
}

extension CollectionsViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let size = collectionView.frame.width * 0.7
//        return CGSize(width: size, height: size)
//    }
    
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 220, height: 360)
        }
}
