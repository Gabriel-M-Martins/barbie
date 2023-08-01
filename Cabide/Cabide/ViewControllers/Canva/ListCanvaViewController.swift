//
//  ListCanvaViewController.swift
//  Cabide
//
//  Created by Gabriel Medeiros Martins on 31/07/23.
//

import UIKit

class ListCanvaViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    var viewModel: ListCanvaViewModel = ListCanvaViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
    }
}

extension ListCanvaViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.canvas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basic", for: indexPath)
        
        let canva = viewModel.canvas[indexPath.row]
        
        cell.textLabel?.text = canva.name
        cell.detailTextLabel?.text = canva.desc
        
        return cell
    }
}
