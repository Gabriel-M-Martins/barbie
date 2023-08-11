//
//  CreateCanva.swift
//  Cabide
//
//  Created by Luana Tais Thomas on 10/08/23.
//

import Foundation
import UIKit

class CreateCanvaViewModel {
    var service: CanvaService = .build()
    
    var collections: [Folder] { CollectionService.data }
    var clothes: [Clothe] { ClotheService.data }
    
    

}

