//
//  ClotheViewController.swift
//  Cabide
//
//  Created by Eduardo Filot Brum on 25/07/23.
//

import UIKit

class ClotheViewController: UIViewController, UIAdaptivePresentationControllerDelegate, CreateClotheDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let clotheCard = UINib(nibName: "ClotheCard", bundle: nil)
    
    var model: ClotheViewModel = ClotheViewModel()
    var isExclusionModeEnabled = false
    var tapGesture: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(clotheCard, forCellWithReuseIdentifier: "clotheCard")
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGesture?.delegate = self
        tapGesture?.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture!)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(longPressGesture)
    }
    
    func confirmDeleteForItem(at indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Excluir peça", message: "Tem certeza de que deseja excluir esta peça?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Excluir", style: .destructive) { _ in
            let selectedClothe = self.model.clothes[indexPath.row]
            self.model.deleteClothe(id: selectedClothe.id ?? UUID())
            self.collectionView.reloadData()
            // Remove o item do modelo de dados e atualiza a coleção
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
            //collectionView.reloadData()
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
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .light) // Escolha o estilo adequado
            feedbackGenerator.prepare()
            feedbackGenerator.impactOccurred()
            collectionView.reloadData()
        } else {
            self.tapGesture?.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        model.service.fetch()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func newClothe(_ sender: Any) {
        performSegue(withIdentifier: "toNewClothe", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewClothe" {
            
            guard let navVC = segue.destination as? UINavigationController,
                  let modalVC = navVC.viewControllers.first as? CreateClotheViewController else { return }
            navVC.presentationController?.delegate = self
            modalVC.delegate = self
        }
    }
    
    func didUpdateData() {
        self.collectionView.reloadData()
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        model.service.fetch()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension ClotheViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UITapGestureRecognizer && otherGestureRecognizer is UILongPressGestureRecognizer {
            return true
        }
        return false
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "clotheCard", for: indexPath) as? ClotheCard
        
        let clothe = model.clothes[indexPath.row]
        let image = UIImage(data: clothe.image ?? Data())
        
        cell?.image.image = image
        
        return cell ?? UICollectionViewCell()
    }
}

extension ClotheViewController: UICollectionViewDelegateFlowLayout {
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
