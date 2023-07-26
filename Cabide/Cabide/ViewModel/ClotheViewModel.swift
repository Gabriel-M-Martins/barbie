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
    
    func returnImage(id: UUID) -> UIImage? {
        if let clothe = clothes.first(where: { $0.id == id }) {
            if let imageData = clothe.image, let image = UIImage(data: imageData) {
                return image
            }
        }
        return nil
    }
    
    func deleteClothe(id: UUID) {
        if let clothe = clothes.first(where: { $0.id == id }) {
            viewContext.delete(clothe)
            saveContext()
            fetchClothes()
        }
    }
    
    func updateClothe(id: UUID, name: String?, description: String?, image: UIImage?){
        if let clothe = clothes.first(where: { $0.id == id}) {
            clothe.name = name
            clothe.description_ = description
            if let imageData = image?.pngData() {
                clothe.image = imageData
            }
            saveContext()
            fetchClothes()
        }
    }
}
