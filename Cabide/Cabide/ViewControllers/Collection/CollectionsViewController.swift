////
////  CollectionViewController.swift
////  Cabide
////
////  Created by Eduardo Filot Brum on 01/08/23.
////
//
//import UIKit
//
//class CollectionsViewController: UIViewController {
//
//    @IBOutlet weak var collectionViewRecents: UICollectionView!
//
//    let largeCard = UINib(nibName: "LargeCard", bundle: nil)
//
//    //TODO: Change viewmodel
//    var viewModel: ListCanvaViewModel = ListCanvaViewModel()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        collectionViewRecents.delegate = self
//        collectionViewRecents.dataSource = self
//        collectionViewRecents.register(largeCard, forCellWithReuseIdentifier: "largeCard")
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        viewModel.service.update()
//        DispatchQueue.main.async {
//            self.collectionViewRecents.reloadData()
//        }
//    }
//}
//
//// MARK: - Collection View
//extension CollectionsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        viewModel.canvas.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "largeCard", for: indexPath) as? LargeCard
//
//        let canva = viewModel.canvas[indexPath.row]
//        let imageData = canva.thumbnail ?? Data()
//
//        cell?.imageView?.image = UIImage(data: imageData)
//        cell?.labelName.text = canva.name
//
//        return cell ?? UICollectionViewCell()
//    }
//}
//
//extension CollectionsViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = collectionView.frame.height * 0.66
//        let height = collectionView.frame.height
//
//        return CGSize(width: width, height: height)
//    }
//}

import UIKit

class CollectionsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
