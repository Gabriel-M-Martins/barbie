//
//  ViewCollectionViewController.swift
//  Cabide
//
//  Created by Luana Tais Thomas on 11/08/23.
//

import UIKit

class ViewCollectionViewController: UIViewController, UIAdaptivePresentationControllerDelegate, UpdateCollectionDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleCollection: UINavigationItem!
    
    let canvaCard = UINib(nibName: "ClotheCard", bundle: nil)
    
    var folder: Folder?
    var canvas: [Canva]?
    
    var model: CollectionViewModel = CollectionViewModel()
    var isExclusionModeEnabled = false
    var tapGesture: UITapGestureRecognizer?
    
    var type = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if folder == nil {
            titleCollection.title = "Todos os looks"
            canvas = model.canvas
            type = 1
            navigationItem.rightBarButtonItem?.isEnabled = false
            navigationItem.rightBarButtonItem?.tintColor = .clear
            navigationItem.rightBarButtonItem?.title = ""
        } else {
            titleCollection.title = folder?.name ?? "Todos os looks"
            canvas = model.getCanvasFolder(folder ?? Folder())
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(canvaCard, forCellWithReuseIdentifier: "clotheCard")
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGesture?.delegate = self
        tapGesture?.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture!)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(longPressGesture)
    }
    
    func confirmDeleteForItem(at indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Excluir look", message: "Tem certeza de que deseja excluir este look da coleção atual?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Excluir", style: .destructive) { _ in
            let selectedCanva = self.canvas?[indexPath.row]
            if self.type == 1 {
                self.model.removeAllCanva(canva: selectedCanva ?? Canva())
                self.canvas = self.model.canvas
                self.collectionView.reloadData()
            } else {
                self.model.removeCanva(id: self.folder?.id ?? UUID(), canva: selectedCanva ?? Canva())
                self.canvas = self.model.getCanvasFolder(self.folder ?? Folder())
                self.collectionView.reloadData()
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        if isExclusionModeEnabled {
            let location = gesture.location(in: collectionView)
            
            if let indexPath = collectionView.indexPathForItem(at: location) {
                confirmDeleteForItem(at: indexPath)
            } else {
                isExclusionModeEnabled = false
                for cell in collectionView.visibleCells {
                    if let clothingCell = cell as? ClotheCard {
                        clothingCell.hideDeleteIcon()
                    }
                }
            }
            collectionView.reloadData()
        }
    }
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            self.tapGesture?.isEnabled = false
            isExclusionModeEnabled = true
            for cell in collectionView.visibleCells {
                if let clothingCell = cell as? ClotheCard {
                    clothingCell.showDeleteIcon()
                }
            }
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
            feedbackGenerator.prepare()
            feedbackGenerator.impactOccurred()
            collectionView.reloadData()
        } else {
            self.tapGesture?.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        model.service.fetch()
        isExclusionModeEnabled = false
        for cell in collectionView.visibleCells {
            if let clothingCell = cell as? ClotheCard {
                clothingCell.hideDeleteIcon()
            }
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func didUpdateData() {
        model.service.fetch()
        folder = model.folders.first(where: { $0.id == folder?.id ?? UUID() })
        canvas = model.getCanvasFolder(folder ?? Folder())
        titleCollection.title = folder?.name ?? "Todos os looks"
        self.collectionView.reloadData()
        
    }
    
    func didDeleteData() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func editCollection(_ sender: Any) {
        performSegue(withIdentifier: "goToUpdate", sender: folder)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToUpdate" {
            guard let modalVC = segue.destination as? UpdateCollectionViewController else { return }
            modalVC.delegate = self
            modalVC.folder = sender as? Folder
        }
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        model.service.fetch()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension ViewCollectionViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UITapGestureRecognizer && otherGestureRecognizer is UILongPressGestureRecognizer {
            return true
        }
        return false
    }
}

// MARK: - Collection View
extension ViewCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        canvas?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "clotheCard", for: indexPath) as? ClotheCard
        
        let canva = canvas?[indexPath.row]
        let image = UIImage(data: canva?.thumbnail ?? Data())
        
        cell?.image.image = image
        
        return cell ?? UICollectionViewCell()
    }
}

extension ViewCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 3
        let spacing: CGFloat = 8
        let totalHorizontalSpacing: CGFloat = (columns - 1.0) * spacing

        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing - 32 - 40) / columns
        let itemSize = CGSize(width: itemWidth, height: itemWidth)
        return itemSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}
