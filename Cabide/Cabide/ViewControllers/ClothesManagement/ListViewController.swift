//
//  ListViewController.swift
//  Cabide
//
//  Created by Luana Tais Thomas on 28/07/23.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let cell: String = "ClotheDetails"
    let segue: String = "goToDetails"
    let viewModel = ClotheViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.clothes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cell, for: indexPath) as! ClotheDetailsCell
        
        let clothe = viewModel.clothes[indexPath.row]
        
        cell.nameLabel.text = clothe.name
        cell.descritionLabel.text = clothe.description_
        cell.clotheImage.image = viewModel.returnImage(id: clothe.id ?? UUID())
        
        return cell
    }
    
}


extension ListViewController: UITableViewDelegate {
    
}
