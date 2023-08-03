//
//  SaveCanvaViewController.swift
//  Cabide
//
//  Created by Gabriel Medeiros Martins on 31/07/23.
//

import UIKit

class SaveCanvaViewController: UIViewController {

    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    
    public var viewModel: EditableCanvaViewModel
    
    init(viewModel: EditableCanvaViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = EditableCanvaViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func save(_ sender: Any) {
        guard let name = nameField.text,
              let description = descriptionField.text else { return }
        
        viewModel.save(name: name, description: description)
        dismiss(animated: true)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
}
