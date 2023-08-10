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
    var viewModel: ListCanvaViewModel = ListCanvaViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let carousel = UINib(nibName: "HorizontalCarouselTableViewCell", bundle: nil)
        self.tableView.register(carousel, forCellReuseIdentifier: "carouselcell")
    }
}

extension CollectionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "carouselcell") as? HorizontalCarouselTableViewCell {
            
            //let item = viewModel.canvas[indexPath.row]
            cell.headerLabel.text = "Looks recentes"
            cell.row = viewModel.canvas
            
            return cell
        }
        return UITableViewCell()
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 600
//    }
}
