//
//  CanvaViewModel.swift
//  Cabide
//
//  Created by Gabriel Medeiros Martins on 02/08/23.
//

import Foundation

class CanvaViewModel {
    enum Buttons {
        case delete
        case main
    }
    
    var clotheService: ClotheService = .build()
    
    var isEditingCanva: Bool = false
    var mainButtonText: String { isEditingCanva ? "Salvar" : "Editar" }
    
    
    var clothes: [Clothe] { clotheService.data }
    
    func buttonPressed(_ button: Buttons) {
        switch button {
        case .main:
            isEditingCanva.toggle()
            self.updateState()
        case .delete:
            break
        }
    }
    
    private func updateState() {
    }
}
