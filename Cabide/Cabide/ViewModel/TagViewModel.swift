//
//  TagViewModel.swift
//  Cabide
//
//  Created by Luana Tais Thomas on 25/07/23.
//

import Foundation
import CoreData

class TagViewModel: ObservableObject {
    @Published var viewContext = DataController.shared.viewContext
    @Published var tags: [Tag] = []
    
    init() {
        fetchTags()
    }
    
    func fetchTags() {
        let request = NSFetchRequest<Tag>(entityName: "Tag")
        
        do {
            tags = try viewContext.fetch(request)
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
