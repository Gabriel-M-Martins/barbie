//
//  OpenedCanvaViewModel.swift
//  Cabide
//
//  Created by Gabriel Medeiros Martins on 26/07/23.
//

import Foundation
import UIKit
import CoreData

struct CanvaPosition : Codable {
    var frame: CGRect
    var transform: CGAffineTransform
}

class EditableCanvaViewModel {
    @Published var viewContext = DataController.shared.viewContext
    var service: ClotheService = ClotheService()
    
    var store: [ClotheAtCanva] = []
    var clothes: [Clothe] { service.data }
    
    func replaceStoreState(clothes: [(Clothe, CanvaPosition)]) {
        let encoder = JSONEncoder()
        var clothesAtCanva: [ClotheAtCanva] = []
        
        for (clothe, position) in clothes {
            let clotheAtCanva = ClotheAtCanva(context: viewContext)
            clotheAtCanva.id = UUID()
            clotheAtCanva.clothe = clothe
            clotheAtCanva.positions = try? encoder.encode(position)
            clothesAtCanva.append(clotheAtCanva)
        }
        
        store = clothesAtCanva
    }
    
    /**
     Saves the store into the shared CoreData context. This isn't yet implemented as the canva's entity doesn't currently exists, so all the canva's info used when creating one are missing from the method.
     */
    func save(name: String, description: String) {
        let canva = Canva(context: viewContext)
        canva.id = UUID()
        canva.name = name
        canva.desc = description
        
        for clotheAtCanva in store {
            canva.addToClothes(clotheAtCanva)
        }
        
        service.save()
    }
}
