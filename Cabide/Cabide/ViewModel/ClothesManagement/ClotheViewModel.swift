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
    
    var tags: [Tag] { TagService.data }
    var selectedTags: [Tag] = []
    
    func toggleTag(_ tag: Tag) {
        if let idx = selectedTags.firstIndex(of: tag) {
            selectedTags.remove(at: idx)
        } else {
            selectedTags.append(tag)
        }
    }
    
    func createClothe(image: UIImage) {
        let clothe = Clothe(context: service.viewContext)

        clothe.id = UUID()
        for tag in selectedTags {
            clothe.addToTags(tag)
        }
        
        if let imageData = image.pngData() {
            clothe.image = imageData
        }
        
        service.update()
    }
    
    func deleteClothe(id: UUID) {
        if let clothe = ClotheService.data.first(where: { $0.id == id }) {
            clothe.active = false
            service.update()
        }
    }
}
