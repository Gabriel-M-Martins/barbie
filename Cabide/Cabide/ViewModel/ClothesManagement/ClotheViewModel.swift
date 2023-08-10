//
//  ClotheViewModel.swift
//  Cabide
//
//  Created by Luana Tais Thomas on 25/07/23.
//

import Foundation
import CoreData
import UIKit

class ClotheViewModel {
    var service: ClotheService = .build()
    var clothes: [Clothe] { ClotheService.data }
    
    func createClothe(image: UIImage) {
        let clothe = Clothe(context: service.viewContext)

        clothe.id = UUID()
        //clothe.name = name
        //clothe.description_ = description
        if let imageData = image.pngData() {
            clothe.image = imageData
        }
        
        service.update()
    }
    
    func deleteClothe(id: UUID) {
        if let clothe = ClotheService.data.first(where: { $0.id == id }) {
            service.viewContext.delete(clothe)
            service.update()
        }
    }
}
