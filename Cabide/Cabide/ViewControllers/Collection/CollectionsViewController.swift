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
    var viewModel: ListCanvaViewModel = ListCanvaViewModel()
    
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
        viewModel.canvas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "largeCard", for: indexPath) as? LargeCard
        
        let canva = viewModel.canvas[indexPath.row]
        let imageData = canva.thumbnail ?? Data()
        
        cell?.imageView?.image = UIImage(data: imageData)
        
        return cell ?? UICollectionViewCell()
    }
}

extension CollectionsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let columns: CGFloat = 2
        let spacing: CGFloat = 1
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
}
