//
//  OpenedCanvaViewModel.swift
//  Cabide
//
//  Created by Gabriel Medeiros Martins on 31/07/23.
//

import Foundation

class OpenedCanvaViewModel {
    @Published var viewContext = DataController.shared.viewContext
    
    func saveContext() -> Bool {
        let saved: ()? = try? viewContext.save()
        return saved != nil ? true : false
    }
    
    func delete(_ canva: Canva) -> Bool {
        viewContext.delete(canva)
        return saveContext()
    }
}
