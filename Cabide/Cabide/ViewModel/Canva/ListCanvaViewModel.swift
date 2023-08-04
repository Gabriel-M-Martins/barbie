//
//  ListCanvaViewModel.swift
//  Cabide
//
//  Created by Gabriel Medeiros Martins on 31/07/23.
//

import Foundation
import CoreData

class ListCanvaViewModel {
    var service: CanvaService = CanvaService.build()
    var canvas: [Canva] { CanvaService.data }
}
