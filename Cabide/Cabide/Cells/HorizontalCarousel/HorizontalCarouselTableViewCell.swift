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
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 150, height: 180)
        flowLayout.minimumLineSpacing = 2.0
        flowLayout.minimumInteritemSpacing = 5.0
        self.collectionView.collectionViewLayout = flowLayout
        self.collectionView.showsHorizontalScrollIndicator = false
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        let cellNib = UINib(nibName: "LargeCard", bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: "largeCard")
    }
    
}

extension HorizontalCarouselTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    // The data we passed from the TableView send them to the CollectionView Model
    //func updateCellWith(row: [CollectionViewCellModel]) {
    //    self.rowWithColors = row
    //    self.collectionView.reloadData()
    //}
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.row?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Set the data for each cell (color and color name)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "largeCard", for: indexPath) as? LargeCard {
            //let canva = self.row?[indexPath.item].thumbnail
            let imageData = self.row?[indexPath.item].thumbnail ?? Data()
            
            cell.imageView?.image = UIImage(data: imageData)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    // Add spaces at the beginning and the end of the collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
}
