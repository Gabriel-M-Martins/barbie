//
//  ClotheViewModel.swift
//  Cabide
//
//  Created by Luana Tais Thomas on 25/07/23.
//

import Foundation
import CoreData
import UIKit

class ClotheViewModel: ObservableObject {
    var service = ClotheService()
    
    func createClothe(name: String, description: String, image: UIImage) {
        let clothe = Clothe(context: service.viewContext)

        clothe.id = UUID()
        clothe.name = name
        clothe.description_ = description
        if let imageData = image.pngData() {
            clothe.image = imageData
        }
        
        service.update()
    }
}
