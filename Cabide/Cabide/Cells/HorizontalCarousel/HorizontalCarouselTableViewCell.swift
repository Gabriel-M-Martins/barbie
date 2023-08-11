//
//  HorizontalCarouselTableViewCell.swift
//  Cabide
//
//  Created by Eduardo Brum on 09/08/23.
//

import UIKit

class HorizontalCarouselTableViewCell: UITableViewCell {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var row: [Canva]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        let cellNib = UINib(nibName: "LargeCard", bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: "largeCard")
        
        configFlowLayout()
    }
    
    func configFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 220, height: 360)
        flowLayout.minimumLineSpacing = 8.0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 8)
        
        self.collectionView.collectionViewLayout = flowLayout
        self.collectionView.showsHorizontalScrollIndicator = false
    }
    
}

extension HorizontalCarouselTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func updateCellWith(row: [Canva]?) {
        self.row = row
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.row?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "largeCard", for: indexPath) as? LargeCard {
            
            let canva = self.row?[indexPath.item]
            let imageData = self.row?[indexPath.item].thumbnail ?? Data()
            
            cell.imageView?.image = UIImage(data: imageData)
            cell.labelName.text = canva?.name
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    // Add spaces at the beginning and the end of the collection view
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 5)
//    }
}
