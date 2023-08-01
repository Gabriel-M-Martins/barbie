//
//  CanvaService.swift
//  Cabide
//
//  Created by Gabriel Medeiros Martins on 31/07/23.
//

import Foundation
import CoreData

public final class CanvaService : CoreDataService {
    @Published var viewContext: NSManagedObjectContext = .init(concurrencyType: .mainQueueConcurrencyType)
    var data: [Canva] = []
}
