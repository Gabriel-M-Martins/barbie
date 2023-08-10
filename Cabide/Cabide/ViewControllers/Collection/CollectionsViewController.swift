////
////  CollectionViewController.swift
////  Cabide
//
//  Created by Eduardo Filot Brum on 01/08/23.
//

import UIKit

class CollectionsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    //TODO: Change viewmodel
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
                cell.headerLabel.text = "Looks recentes"
                cell.row = viewModel.getRecentCanvas()
                cell.updateCellWith(row: viewModel.getRecentCanvas())
                
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "carouselcell") as? HorizontalCarouselTableViewCell {
                cell.headerLabel.text = viewModel.folders[indexPath.row].name
                cell.row = viewModel.getCanvasFolder(viewModel.folders[indexPath.row])
    //            cell.updateCellWith(row: viewModel.folders[indexPath.row].canvas)
                
                return cell
            }
        }
        
        return UITableViewCell()
        
    }
}
