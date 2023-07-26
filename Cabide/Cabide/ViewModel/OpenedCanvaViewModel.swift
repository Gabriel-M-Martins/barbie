//
//  OpenedCanvaViewModel.swift
//  Cabide
//
//  Created by Gabriel Medeiros Martins on 26/07/23.
//

import Foundation
import UIKit

class OpenedCanvaViewModel {
    /// ID : (Transform, Frame)
    /// Stores this canva' "session" in a dictionary to be later saved on CoreData.
    private var canvaStore: [UUID : (transform: CGAffineTransform, frame: CGRect)] = [:]
    
    /**
     Adds or updates an image to the store.
     - Parameters:
        - id: the image's UUID.
     */
    func putImage(id: UUID, _ transform: CGAffineTransform, _ frame: CGRect) {
        canvaStore[id] = (transform, frame)
    }
    
    /**
     Removes an image from the store.
     - Parameters:
        - id: the image's UUID.
    */
    func removeImage(id: UUID) {
        canvaStore.removeValue(forKey: id)
    }
    
    /**
     Saves the store into the shared CoreData context. This isn't yet implemented as the canva's entity doesn't currently exists, so all the canva's info used when creating one are missing from the method.
     */
    func save() -> Bool {
        return false
    }
    
    /**
     Loads images from shared CoreData context and their respective UUIDs.
     - Returns: A tuple list where image is an UIImage and id is it's UUID.
     */
    func loadImages() -> [(image: UIImage, id: UUID)] {
        return []
    }
}
