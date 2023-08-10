//
//  TagViewModel.swift
//  Cabide
//
//  Created by Luana Tais Thomas on 25/07/23.
//

import Foundation
import CoreData

class TagViewModel: ObservableObject {
    var service: TagService = .build()
    
    func delete(_ tag: Tag) {
        service.delete(tag)
    }
    
    func create(name: String, clothes: [Clothe]) {
        let newTag = Tag(context: service.viewContext)
        newTag.id = .init()
        newTag.name = name
        newTag.clothes = NSSet(array: clothes)
        service.update()
    }
    
    func update(tag: Tag, newName: String?, clothes: [Clothe]?) {
        guard let idx = TagService.data.firstIndex(of: tag) else { return }
        
        if let newName = newName {
            TagService.data[idx].name = newName
        }
        
        if let clothes = clothes {
            TagService.data[idx].clothes = NSSet(array: clothes)
        }
    }
}
