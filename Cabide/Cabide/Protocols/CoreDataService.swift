//
//  CoreDataService.swift
//  Cabide
//
//  Created by Gabriel Medeiros Martins on 31/07/23.
//

import Foundation
import CoreData

protocol CoreDataService<T> where T : NSManagedObject {
    associatedtype T
    
    var viewContext: NSManagedObjectContext { get set }
    var data: [T] { get set }
    
    init()
    
    func save()
    mutating func fetch()
    mutating func update()
    mutating func delete(_ object: T)
}

extension CoreDataService {
    static func build() -> Self {
        var object = Self.init()
//        self.init()
        object.viewContext = DataController.shared.viewContext
        object.fetch()
        return object
    }
    
    func save() {
        do {
            try viewContext.save()
        } catch {
            // !!!
            print("Error saving ----------------------------------------")
        }
    }
    
    mutating func fetch() {
        let request = NSFetchRequest<T>(entityName: T.description())
        
        do {
            data = try viewContext.fetch(request)
        } catch {
            // !!!
            print("DEBUG: Some error occured while fetching")
        }
    }
    
    mutating func update() {
        save()
        fetch()
    }
    
    mutating func delete(_ object: T) {
        viewContext.delete(object)
        update()
    }
}
