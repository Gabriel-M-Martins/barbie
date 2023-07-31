//
//  CanvaService.swift
//  Cabide
//
//  Created by Gabriel Medeiros Martins on 31/07/23.
//

import Foundation
import CoreData

public final class CanvaService : CoreDataService {
    // firula que vai ser sobrescrita no init padrao do CoreDataService
    @Published var viewContext: NSManagedObjectContext = .init(concurrencyType: .mainQueueConcurrencyType)
    var data: [Canva] = []
}
