//
//  ViewController.swift
//  Cabide
//
//  Created by Gabriel Medeiros Martins on 24/07/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func clothing(_ sender: Any) {
        performSegue(withIdentifier: "toClothe", sender: nil)
    }
    
    @IBAction func canva(_ sender: Any) {
        performSegue(withIdentifier: "toOpenedCanva", sender: nil)
    }
    
}

//class HomeViewController: UIViewController, HomeProtocol {
//
//    var label: UILabel = UILabel(frame: .zero)
//
//    let viewModel: HomeViewModel
//
//    init(viewModel: HomeViewModel) {
//        self.viewModel = viewModel
//        super.init()
//        self.viewModel.delegate = self
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//    }
//
//    func reloadLabel(texto: String) {
//        label.text = texto
//    }
//
//}
//
//protocol HomeProtocol: AnyObject {
//    func reloadLabel(texto: String)
//}
//
//class HomeViewModel {
//
//    var listaDeFotos: [] = []
//
//    weak var delegate: HomeProtocol?
//
//    func getDataFromCoreData() {
//        delegate?.reloadLabel(texto: "asd")
//    }
//}
//
