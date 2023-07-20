//
//  DataManager.swift
//  Canva
//
//  Created by Gabriel Medeiros Martins on 20/07/23.
//

import Foundation
import CoreData

class DataManager {
    static let shared = DataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Canva")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    func canva(name: String) -> Canva {
        let canva = Canva(context: persistentContainer.viewContext)
        canva.name = name
        return canva
    }
    
    func image(frame: CGRect, canva: Canva) -> Image {
        let image = Image(context: persistentContainer.viewContext)
        image.x = Float(frame.origin.x)
        image.y = Float(frame.origin.y)
        image.width = Float(frame.width)
        image.height = Float(frame.height)
        canva.addToImages(image)
        
        return image
    }
    
    func canvases() -> [Canva] {
        let request: NSFetchRequest<Canva> = Canva.fetchRequest()
        var fetchedCanvases: [Canva] = []
        
        do {
            fetchedCanvases = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetching singers \(error)")
        }
        
        return fetchedCanvases
    }
    
    func images(canva: Canva) -> [Image] {
        let request: NSFetchRequest<Image> = Image.fetchRequest()
        request.predicate = NSPredicate(format: "canva = %@", canva)
        
        var fetchedImages: [Image] = []
        
        do {
            fetchedImages = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetching images \(error)")
        }
        
        return fetchedImages
    }

    func deleteCanva(canva: Canva) {
        let context = persistentContainer.viewContext
        context.delete(canva)
        save()
    }
    
    func deleteImage(image: Image) {
        let context = persistentContainer.viewContext
        context.delete(image)
        save()
    }
    
    //Core Data Saving support
    func save() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
