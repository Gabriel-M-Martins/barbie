//
//  ClotheDetailsViewModel.swift
//  Cabide
//
//  Created by Luana Tais Thomas on 31/07/23.
//

import Foundation
import CoreData
import UIKit

class ClotheDetailsViewModel {
    var service = ClotheService()
    
    func returnImage(id: UUID?) -> UIImage {
        if let clothe = service.clothes.first(where: { $0.id == id }) {
            if let imageData = clothe.image, let image = UIImage(data: imageData) {
                return image
            }
        }
        return UIImage()
    }

    func deleteClothe(id: UUID) {
        if let clothe = service.clothes.first(where: { $0.id == id }) {
            service.viewContext.delete(clothe)
            service.update()
        }
    }

    func updateClothe(id: UUID, name: String?, description: String?, image: UIImage?){
        if let clothe = service.clothes.first(where: { $0.id == id}) {
            clothe.name = name
            clothe.description_ = description
            if let imageData = image?.pngData() {
                clothe.image = imageData
            }
            service.update()
        }
    }
}
