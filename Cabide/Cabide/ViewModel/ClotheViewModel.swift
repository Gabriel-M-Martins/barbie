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
    @Published var viewContext = DataController.shared.viewContext
    var clothes: [Clothe] = []
    
    init() {
        fetchClothes()
    }
    
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
    
    func createClothe(name: String, description: String, image: UIImage) {
        let clothe = Clothe(context: viewContext)
        
        clothe.id = UUID()
        clothe.name = name
        clothe.description_ = description
        if let imageData = image.pngData() {
            clothe.image = imageData
        }
        
        saveContext()
        fetchClothes()
    }
}
