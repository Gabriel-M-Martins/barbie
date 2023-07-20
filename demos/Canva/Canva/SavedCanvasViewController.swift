//
//  SavedCanvasViewController.swift
//  Canva
//
//  Created by Gabriel Medeiros Martins on 19/07/23.
//

import UIKit

class SavedCanvasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        canvases = DataManager.shared.canvases()
        
        table.delegate = self
        table.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        canvases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "basic", for: indexPath)
        
        cell.textLabel?.text = canvases[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let canva = canvases[indexPath.row]
        performSegue(withIdentifier: "toSavedCanva", sender: canva)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSavedCanva" {
            guard let vc = segue.destination as? OpenedSavedCanvasViewController else { return }
            
            guard let info = sender as? Canva else { return }
            
            vc.canva = info
        }
    }
}
