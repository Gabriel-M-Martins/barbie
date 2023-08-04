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
    var context: NSManagedObjectContext { canvaService.viewContext }
    
    var clotheService: ClotheService = ClotheService.build()
    var canvaService: CanvaService = CanvaService.build()
    
    var store: [ClotheAtCanva] = []
    var thumbnail: UIImage?
    var clothes: [Clothe] { ClotheService.data }
    
//    func replaceStoreState(clothes: [(Clothe, CanvaPosition)]) {
//        let encoder = JSONEncoder()
//        var clothesAtCanva: [ClotheAtCanva] = []
//
//        for (clothe, position) in clothes {
//            let clotheAtCanva = ClotheAtCanva(context: viewContext)
//            clotheAtCanva.id = UUID()
//            clotheAtCanva.clothe = clothe
//            clotheAtCanva.positions = try? encoder.encode(position)
//            clothesAtCanva.append(clotheAtCanva)
//        }
//
//        store = clothesAtCanva
//    }
    
    func replaceStoreState(canva: UIView) {
        let encoder = JSONEncoder()
        var clothesAtCanva: [ClotheAtCanva] = []
        
        let clothesPositions = canva.subviews.reduce(into: [(Clothe, CanvaPosition)]()) { partialResult, object in
            guard let clothe = object.layer.value(forKey: "clothe") as? Clothe else { return }
            
            let position = CanvaPosition(frame: object.frame, transform: object.transform)
            partialResult.append((clothe, position))
        }
        
        for (clothe, position) in clothesPositions {
            let clotheAtCanva = ClotheAtCanva(context: context)
            clotheAtCanva.id = UUID()
            clotheAtCanva.clothe = clothe
            clotheAtCanva.positions = try? encoder.encode(position)
            clothesAtCanva.append(clotheAtCanva)
        }

        store = clothesAtCanva
        thumbnail = canva.asImage()
    }
    
    /**
     Saves the store into the shared CoreData context. This isn't yet implemented as the canva's entity doesn't currently exists, so all the canva's info used when creating one are missing from the method.
     */
    func save(name: String, description: String) {
        let canva = Canva(context: context)
        canva.id = UUID()
        canva.name = name
        canva.desc = description
        canva.thumbnail = thumbnail?.pngData()
        
        for clotheAtCanva in store {
            canva.addToClothes(clotheAtCanva)
        }
        
        canvaService.update()
    }
}
