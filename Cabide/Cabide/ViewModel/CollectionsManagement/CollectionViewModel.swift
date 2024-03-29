//
//  CollectionViewModel.swift
//  Cabide
//
//  Created by Luana Tais Thomas on 31/07/23.
//

import Foundation
import CoreData
import UIKit

class CollectionViewModel {
    var service: CollectionService = .build()
    var folders: [Folder] { CollectionService.data }
    
    var serviceCanvas: CanvaService = .build()
    var canvas: [Canva] { CanvaService.data }
    
    func deleteCollection(id: UUID) {
        if let collection = folders.first(where: { $0.id == id }) {
            
            for canva in getCanvasFolder(collection) ?? [Canva()]{
                removeCanva(id: collection.id ?? UUID(), canva: canva)
            }
    
            service.viewContext.delete(collection)
            service.update()
        }
    }
    
    func updateCollection(id: UUID, name: String?, canvas: [Canva]){
        if let collection = folders.first(where: { $0.id == id}) {
            collection.name = name
            service.update()

            for canva in getCanvasFolder(collection) ?? [Canva()]{
                removeCanva(id: collection.id ?? UUID(), canva: canva)
            }
            
            for canva in canvas {
                addCanva(id: collection.id ?? UUID(), canva: canva)
            }
            
            service.update()
        }
    }
    
    func getCollections() -> [Folder] {
        return folders
    }
    
    func createCollection(name: String, canvas: [Canva]) {
        let collection = Folder(context: service.viewContext)
        
        collection.id = UUID()
        collection.name = name
        service.update()

        for canva in canvas {
            addCanva(id: collection.id ?? UUID(), canva: canva)
        }
        
        service.update()
    }
    
    func addCanva(id: UUID, canva: Canva) {
        if let collection = folders.first(where: { $0.id == id }) {
            collection.addToCanvas(canva)
            canva.addToFolders(collection)
            service.update()
        }
    }
    
    func getRecentCanvas() -> [Canva] {
        return canvas.reversed().suffix(7)
    }
    
    func removeCanva(id: UUID, canva: Canva) {
//        folders.filter
        if let collection = folders.first(where: { $0.id == id }) {

            let mutableCanvasSet = collection.mutableSetValue(forKey: "canvas") as NSMutableSet
            let mutableFolderSet = canva.mutableSetValue(forKey: "folders") as NSMutableSet
            
            mutableCanvasSet.remove(canva)
            mutableFolderSet.remove(collection)

            service.update()
        }
    }
    
    func removeAllCanva(canva: Canva) {
        serviceCanvas.viewContext.delete(canva)
        serviceCanvas.update()
        service.update()
    }
    
    func getRecentCanvas() -> [Canva]? {
        guard self.canvas != nil else {
            return []
        }
        return canvas
    }
    
    func getCanvasFolder(_ folder: Folder) -> [Canva]? {
        guard
            let canvasSet = folder.canvas,
            let canvas = canvasSet.allObjects as? [Canva] else {
            return []
        }
        
        return canvas
    }
    
}
