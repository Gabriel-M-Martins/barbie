//
//  ListViewModel.swift
//  Cabide
//
//  Created by Luana Tais Thomas on 31/07/23.
//

import Foundation
import CoreData
import UIKit

class ListViewModel: ObservableObject {
    var service = ClotheService.build()
    var clothes: [Clothe] { service.data }
}
