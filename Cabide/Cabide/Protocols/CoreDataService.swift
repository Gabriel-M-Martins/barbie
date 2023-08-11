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
        var object = Self.init()
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
        
        Self.data = (try? viewContext.fetch(request)) ?? Self.data
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

// TODO: ! http://equinocios.com/ios/2016/03/16/protocol-oriented-programming/ Renan apoiou esse link aqui parece mt bala, vou ler e depois refazer as parada aqui


/*
 protocol Foo<T> where T : NSManagedObject {
    associatedtype T

    static var data: [T] { get set }
    static var context: NSManagedObjectContext { get set }

    init()
}

extension Foo {
    static var context: NSManagedObjectContext { DataController.shared.viewContext }

    static private func save() {
        try? Self.context.save()
    }

    static func fetch() {
        let request = NSFetchRequest<T>(entityName: T.description())
        data = (try? context.fetch(request)) ?? data
    }

    static func update() {
        save()
        fetch()
    }

    static func delete(_ object: T) {
        context.delete(object)
        update()
    }
}

public final class Bar : Foo<Canva> {}
*/
