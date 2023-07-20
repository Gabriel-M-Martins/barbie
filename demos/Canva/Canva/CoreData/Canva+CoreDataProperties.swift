//
//  Canva+CoreDataProperties.swift
//  Canva
//
//  Created by Gabriel Medeiros Martins on 20/07/23.
//
//

import Foundation
import CoreData


extension Canva {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Canva> {
        return NSFetchRequest<Canva>(entityName: "Canva")
    }

    @NSManaged public var name: String?
    @NSManaged public var images: NSSet?

}

// MARK: Generated accessors for images
extension Canva {

    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: Image)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: Image)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSSet)

}

extension Canva : Identifiable {

}
