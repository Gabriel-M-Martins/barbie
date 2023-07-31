//
//  ListViewModel.swift
//  Cabide
//
//  Created by Luana Tais Thomas on 31/07/23.
//

import Foundation
import CoreData
import UIKit

class ListViewModel: ObservableObject {
    var service = ClotheService()
    
    func returnImage(id: UUID?) -> UIImage {
        if let clothe = service.clothes.first(where: { $0.id == id }) {
            if let imageData = clothe.image, let image = UIImage(data: imageData) {
                return image
            }
        }
        return UIImage()
    }

    func getClothes() -> [Clothe] {
        return service.clothes
    }
}
