//
//  CanvaViewModel.swift
//  Cabide
//
//  Created by Gabriel Medeiros Martins on 02/08/23.
//

import Foundation

class CanvaViewModel {
    var clotheService: ClotheService = .build()
    
    var isEditingCanva: Bool = false
    var mainButtonText: String { isEditingCanva ? "Salvar" : "Editar" }
    
    
    var clothes: [Clothe] { clotheService.data }
    
    func changeCanvaState() {
        isEditingCanva.toggle()
    }
    
    func delete() {
        
    }
}
