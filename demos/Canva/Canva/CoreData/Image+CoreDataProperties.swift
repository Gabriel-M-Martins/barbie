//
//  Image+CoreDataProperties.swift
//  Canva
//
//  Created by Gabriel Medeiros Martins on 20/07/23.
//
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var height: Float
    @NSManaged public var width: Float
    @NSManaged public var x: Float
    @NSManaged public var y: Float
    @NSManaged public var canva: Canva?

}

extension Image : Identifiable {

}
