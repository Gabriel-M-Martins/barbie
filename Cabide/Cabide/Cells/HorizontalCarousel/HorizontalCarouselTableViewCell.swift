//
//  HorizontalCarouselTableViewCell.swift
//  Cabide
//
//  Created by Eduardo Brum on 09/08/23.
//

import UIKit

enum TypeCarousel {
    case large
    case small
}

class HorizontalCarouselTableViewCell: UITableViewCell, UIAdaptivePresentationControllerDelegate, UITableViewDelegate {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerView: UIView!
    
    var typeCarousel: TypeCarousel?
    var row: [Canva]?
    var folder: Folder?
    var type: Int?
    
    var delegate: HorizontalCarouselDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        configTypeCarousel()
        configFlowLayout()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openCollection))
//        tapGesture.cancelsTouchesInView = false
        headerView.addGestureRecognizer(tapGesture)
    }
    
    func configTypeCarousel() {
        let cellNib = UINib(nibName: "LargeCard", bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: "largeCard")
        
        let smallCellNib = UINib(nibName: "ClotheCard", bundle: nil)
        self.collectionView.register(smallCellNib, forCellWithReuseIdentifier: "clotheCard")
    }
    
    func configFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 8.0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 8)
        
        self.collectionView.collectionViewLayout = flowLayout
        self.collectionView.showsHorizontalScrollIndicator = false
    }
    
    @objc func openCollection() {
        delegate?.goToSegue(folder: folder)
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
        if self.typeCarousel == .large {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "largeCard", for: indexPath) as? LargeCard {
                
                let canva = self.row?[indexPath.item]
                let imageData = self.row?[indexPath.item].thumbnail ?? Data()
                
                cell.imageView?.image = UIImage(data: imageData)
                cell.labelName.text = canva?.name
                
                return cell
            }
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "clotheCard", for: indexPath) as? ClotheCard {
                
                let imageData = self.row?[indexPath.item].thumbnail ?? Data()
                
                cell.image?.image = UIImage(data: imageData)
                
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
}

extension HorizontalCarouselTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.typeCarousel == .large ? CGSize(width: 220, height: 360) : CGSize(width: 124, height: 135)
        
        return size
    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    ////        guard collectionView == clothesCollection else { return collectionView.safeAreaInsets }
    //        return UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    //    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    //        return 8
    //    }
}

protocol HorizontalCarouselDelegate: AnyObject {
    func goToSegue(folder: Folder?)
}
