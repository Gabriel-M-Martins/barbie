//
//  ClotheViewModel.swift
//  Cabide
//
//  Created by Luana Tais Thomas on 25/07/23.
//

import Foundation
import CoreData

class ClotheViewModel: ObservableObject {
    @Published var viewContext = DataController.shared.viewContext
    @Published var clothesArray: [Clothe] = []
    
    init() {
        fetchClothes()
    }
    
    func fetchClothes() {
        let request = NSFetchRequest<Clothe>(entityName: "Clothe")
        
        do {
            clothesArray = try viewContext.fetch(request)
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
}
