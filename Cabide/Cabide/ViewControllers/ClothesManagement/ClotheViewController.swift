//
//  ClotheViewController.swift
//  Cabide
//
//  Created by Eduardo Filot Brum on 25/07/23.
//

import UIKit

class ClotheViewController: UIViewController, UIAdaptivePresentationControllerDelegate {
        
    @IBOutlet weak var collectionView: UICollectionView!
    
    let clotheCard = UINib(nibName: "LargeCard", bundle: nil)
    
    var model: ClotheViewModel = ClotheViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(clotheCard, forCellWithReuseIdentifier: "largeCard")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        model.service.update()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func newClothe(_ sender: Any) {
        performSegue(withIdentifier: "toNewClothe", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewClothe" {
            guard let navVC = segue.destination as? UINavigationController else { return }
            
            navVC.presentationController?.delegate = self
        }
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        model.service.update()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

// MARK: - Collection View
extension ClotheViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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

extension ClotheViewController: UICollectionViewDelegateFlowLayout {
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
