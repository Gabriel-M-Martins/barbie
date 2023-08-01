//
//  ClotheService.swift
//  Cabide
//
//  Created by Luana Tais Thomas on 31/07/23.
//

import Foundation
import CoreData

public final class ClotheService: CoreDataService {
    @Published var viewContext: NSManagedObjectContext = DataController.shared.viewContext
    var data: [Clothe] = []
}
