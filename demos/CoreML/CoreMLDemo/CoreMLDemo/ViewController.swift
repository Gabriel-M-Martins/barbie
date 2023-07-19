//
//  ViewController.swift
//  CoreMLDemo
//
//  Created by Eduardo Filot Brum on 19/07/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageTest: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func removeBg(_ sender: Any) {
        DispatchQueue.main.async {
            self.imageTest.image = self.imageTest.image?.removeBackground(returnResult: .finalImage)
        }
    }
    
}

