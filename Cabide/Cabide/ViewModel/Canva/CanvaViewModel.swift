//
//  CanvaViewModel.swift
//  Cabide
//
//  Created by Gabriel Medeiros Martins on 02/08/23.
//

import Foundation
import UIKit

class CanvaViewModel {
    enum Button: Int {
        case delete
        case main
    }
    
    enum State {
        case visualization
        case editing
    }
    
    weak var delegate: CanvaDelegate?
    
    var clotheService: ClotheService = .build()
    var clothes: [Clothe] { clotheService.data }
    
    var state: State = .editing
    var canva: Canva?
    
    var hideNameLabel: Bool {
        switch state {
        case .visualization:
            return false
        case .editing:
            return true
        }
    }
    var hideNameTextField: Bool { !hideNameLabel }
    
    var collectionIsUserInteractionEnabled: Bool {
        switch state {
        case .visualization:
            return false
        case .editing:
            return true
        }
    }
    
    var canvaName: String { canva?.name ?? "Default" }
    
    var mainButtonImage: UIImage? {
        switch state {
        case .visualization:
            return UIImage(systemName: "pencil")
        case .editing:
            return UIImage(systemName: "checkmark.circle.fill")
        }
    }
    
    func buttonPressed(_ button: Button) {
        switch button {
        case .main:
            self.updateState()
        case .delete:
            break
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
    func setupState()
}
