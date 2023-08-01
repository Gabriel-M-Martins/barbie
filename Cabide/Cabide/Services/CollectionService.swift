//
//  CollectionService.swift
//  Cabide
//
//  Created by Luana Tais Thomas on 31/07/23.
//

import Foundation
import CoreData

public class CollectionService {
    @Published var viewContext = DataController.shared.viewContext
    var collections: [Collection] = []
    
    init() {
        fetchCollections()
    }
    
    func fetchCollections() {
        let request = NSFetchRequest<Collection>(entityName: "Collection")
        
        do {
            collections = try viewContext.fetch(request)
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
    
    func update() {
        self.saveContext()
        self.fetchCollections()
    }
}


