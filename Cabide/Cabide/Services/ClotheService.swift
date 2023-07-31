//
//  ClotheService.swift
//  Cabide
//
//  Created by Luana Tais Thomas on 31/07/23.
//

import Foundation
import CoreData

public final class ClotheService: CoreDataService {
    // firula que vai ser sobrescrita no init padrao do CoreDataService
    @Published var viewContext: NSManagedObjectContext = .init(concurrencyType: .mainQueueConcurrencyType)
    var data: [Clothe] = []
}
