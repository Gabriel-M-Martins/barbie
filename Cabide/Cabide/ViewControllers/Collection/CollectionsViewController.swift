////
////  CollectionViewController.swift
////  Cabide
//
//  Created by Eduardo Filot Brum on 01/08/23.
//

import UIKit

class CollectionsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: CollectionViewModel = CollectionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let carousel = UINib(nibName: "HorizontalCarouselTableViewCell", bundle: nil)
        self.tableView.register(carousel, forCellReuseIdentifier: "carouselcell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.service.fetch()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension CollectionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : viewModel.folders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "carouselcell") as? HorizontalCarouselTableViewCell {
                cell.typeCarousel = .large
                cell.headerLabel.text = "Todos os looks"
                cell.headerLabel.font = UIFont(name: cell.headerLabel.font.fontName, size: 22)
                cell.row = viewModel.getRecentCanvas()
                cell.updateCellWith(row: viewModel.getRecentCanvas())
                cell.delegate = self
                cell.folder = nil

                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "carouselcell") as? HorizontalCarouselTableViewCell {
                cell.typeCarousel = .small
                cell.headerLabel.text = viewModel.folders[indexPath.row].name
                cell.headerLabel.font = UIFont(name: cell.headerLabel.font.fontName, size: 18)
                cell.row = viewModel.getCanvasFolder(viewModel.folders[indexPath.row])
                cell.updateCellWith(row: viewModel.getCanvasFolder(viewModel.folders[indexPath.row]))
                cell.delegate = self
                cell.folder = viewModel.folders[indexPath.row]
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 420
        } else {
            return 190
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToViewCollection" {
            guard let destination = segue.destination as? ViewCollectionViewController else { return }
            destination.folder = sender as? Folder
            return
        }
        
        if segue.identifier == "goToCanva" {
            guard let navVc = segue.destination as? UINavigationController,
                  let vc = navVc.topViewController as? CanvaViewController,
                  let canva = sender as? Canva else { return }
            
            vc.model = CanvaViewModel(canva: canva, state: .visualization)
            return
        }
    }
}

extension CollectionsViewController: HorizontalCarouselDelegate {
    func goToFolder(folder: Folder?) {
        performSegue(withIdentifier: "goToViewCollection", sender: folder)
    }
    
    func goToCanva(canva: Canva) {
        performSegue(withIdentifier: "goToCanva", sender: canva)
    }
}
