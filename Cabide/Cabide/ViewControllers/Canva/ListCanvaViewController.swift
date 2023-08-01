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
        table.delegate = self
    }
}

extension ListCanvaViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.canvas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basic", for: indexPath)
        
        let canva = viewModel.canvas[indexPath.row]
        let imageData = canva.thumbnail ?? Data()
        
        cell.textLabel?.text = canva.name
        cell.detailTextLabel?.text = canva.desc
        cell.imageView?.image = UIImage(data: imageData)
        return cell
    }
}

extension ListCanvaViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let canva = viewModel.canvas[indexPath.row]
        performSegue(withIdentifier: "toOpenedCanva", sender: canva)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toOpenedCanva" {
            guard let vc = segue.destination as? OpenedCanvaViewController,
                  let info = sender as? Canva else { return }
            
            vc.canva = info
        }
    }
}
