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
    
    static var data: [T] { get set }
    
    init()
    
    func save()
    mutating func fetch()
    mutating func update()
    mutating func delete(_ object: T)
}

extension CoreDataService {
    var viewContext: NSManagedObjectContext { DataController.shared.viewContext }
    
    static func build() -> Self {
        print("build", type(of: self))
        var object = Self.init()
        object.fetch()
        return object
    }
    
    func save() {
        print("save")
        do {
            try viewContext.save()
        } catch {
            // !!!
            print("Error saving ----------------------------------------")
        }
    }
    
    mutating func fetch() {
        print("fetch")
        let request = NSFetchRequest<T>(entityName: T.description())
        
        
        Self.data = (try? viewContext.fetch(request)) ?? Self.data
    }
    
    mutating func update() {
        print("update")
        save()
        fetch()
    }
    
    mutating func delete(_ object: T) {
        viewContext.delete(object)
        update()
    }
}
