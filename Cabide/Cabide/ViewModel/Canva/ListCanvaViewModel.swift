//
//  ListCanvaViewModel.swift
//  Cabide
//
//  Created by Gabriel Medeiros Martins on 31/07/23.
//

import Foundation
import CoreData

class ListCanvaViewModel {
    @Published var viewContext = DataController.shared.viewContext
    var canvas: [Canva] = []
    
    init() {
        fetch()
    }
    
    private func fetch() {
        let request = NSFetchRequest<Canva>(entityName: "Canva")
        
        do {
            canvas = try viewContext.fetch(request)
        } catch {
            print("DEBUG: Some error occured while fetching")
        }
    }
}
