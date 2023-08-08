//
//  CanvaViewModel.swift
//  Cabide
//
//  Created by Gabriel Medeiros Martins on 02/08/23.
//

import Foundation
import UIKit

class CanvaViewModel {
    enum State {
        case visualization
        case editing
    }
    
    weak var delegate: CanvaDelegate?
    
    var clotheService: ClotheService = .build()
    var clothes: [Clothe] { clotheService.data }
    
    var canvaService: CanvaService = .build()
    var canva: Canva
    var canvaName: String { canva.name ?? "Novo canva" }
    
    var state: State
    
    // MARK: - Hide name label or text field
    var hideNameLabel: Bool {
        switch state {
        case .visualization:
            return false
        case .editing:
            return true
        }
    }
    var hideNameTextField: Bool { !hideNameLabel }
    
    // MARK: - Collections is interactable
    var collectionIsUserInteractionEnabled: Bool {
        switch state {
        case .visualization:
            return false
        case .editing:
            return true
        }
    }
    
    var mainButtonImage: UIImage? {
        switch state {
        case .visualization:
            return UIImage(systemName: "pencil")
        case .editing:
            return UIImage(systemName: "checkmark.circle.fill")
        }
    }
    
    init(canva: Canva, state: State) {
        self.canva = canva
        self.state = state
    }
    
    init() {
        self.canva = Canva(context: canvaService.viewContext)
        self.state = .visualization
    }
    
    func buttonPressed() {
        switch state {
        case .visualization:
            self.updateState()
        case .editing:
            guard let delegate = delegate else { return }
            
            canva.name = delegate.canvaName
            
            for (view, clothe) in delegate.objects {
                let newClotheAtCanva = ClotheAtCanva(context: canvaService.viewContext)
                
                
                let position = ClotheAtCanvaPosition(position: view.frame, transform: view.transform)
                let encoder = JSONEncoder()
                
                newClotheAtCanva.clothe = clothe
                newClotheAtCanva.position = try? encoder.encode(position)
                
                canva.addToClothes(newClotheAtCanva)
            }
            
            // call segue to save sheet
            // canvaService.update()
        }
    }

    private func updateState() {
        switch state {
        case .visualization:
            state = .editing
        case .editing:
            state = .visualization
        }
        
        delegate?.setupState()
    }
}


protocol CanvaDelegate : AnyObject {
    var canvaName: String? { get }
    var objects: [(view: UIView, clothe: Clothe)] { get set }
    
    func setupState()
    func segueToSaveModal()
}

struct ClotheAtCanvaPosition : Codable {
    var position: CGRect
    var transform: CGAffineTransform
}
