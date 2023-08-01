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

class OpenedCanvaViewModel {
    @Published var viewContext = DataController.shared.viewContext
    var clothes: [Clothe] = []
    
    init() {
        fetchClothes()
    }
    
    // ------------------------------------------------------------------------------------------------------------------------------ this will be moved into a static service
    func fetchClothes() {
        let request = NSFetchRequest<Clothe>(entityName: "Clothe")
        
        do {
            clothes = try viewContext.fetch(request)
        } catch {
            print("DEBUG: Some error occured while fetching")
        }
    }
    
    func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving")
        }
    }
    // ------------------------------------------------------------------------------------------------------------------------------ ^
    
    var store: [ClotheAtCanva] = []
    
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
    func save(name: String, description: String) -> Bool {
        var canva = Canva(context: viewContext)
        canva.id = UUID()
        canva.name = name
        canva.desc = description
        
        for clotheAtCanva in store {
            canva.addToClothes(clotheAtCanva)
        }
                
        return false
    }
}
