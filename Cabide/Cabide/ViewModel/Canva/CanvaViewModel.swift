//
//  CanvaViewModel.swift
//  Cabide
//
//  Created by Gabriel Medeiros Martins on 02/08/23.
//

import Foundation
import UIKit

class CanvaViewModel {
    enum State {
        case visualization
        case editing
    }
    
    weak var canvaDelegate: CanvaDelegate?
    weak var canvaNameDelegate: CanvaNameDelegate?
    
    var clotheService: ClotheService = .build()
    
    var canvas: [Canva] { CanvaService.data }
    
    var clothes: [Clothe] {
        switch self.state {
        case .editing:
            if selectedTags.count == 0 { return ClotheService.data }
            
            return ClotheService.data.filter { clothe in
                (clothe.tags?.allObjects as? [Tag])?.contains(where: { selectedTags.contains($0)} ) ?? false
            }
        case .visualization:
            guard let canva = self.canva else { return [] }
            
            var clothes = (canva.clothes?.allObjects as? [ClotheAtCanva])?
                .reduce([Clothe](), { partialResult, clotheAtCanva in
                    guard let clothe = clotheAtCanva.clothe else { return partialResult }
                    var mutableResult = partialResult
                    mutableResult.append(clothe)
                    return mutableResult
                }) ?? []
            
            if selectedTags.count > 0 {
               clothes = clothes.filter({ clothe in
                   (clothe.tags?.allObjects as? [Tag])?.contains(where: { selectedTags.contains($0)} ) ?? false
               })
            }
            
            return clothes
        }
        
//        return ClotheService.data.filter { clothe in
//            guard let tags = clothe.tags,
//                  tags.count > 0 else { return false }
//
//            return NSSet(array: selectedTags).isSubset(of: tags as! Set<AnyHashable>)
//        }
    }
    
    var tags: [Tag] {
        let foo = TagService.data.filter({ !selectedTags.contains($0) })
        return selectedTags + foo
    }
    
    var canvaService: CanvaService = .build()
    var canva: Canva?
    var canvaName: String { canvaNameDelegate?.canvaName ?? canva?.name ?? "Novo canva" }
    
    var tagService: TagService = .build()
    var selectedTags: [Tag] = []
    
    var collectionService: CollectionService = .build()
    var folders: [Folder] { CollectionService.data }
    var selectedFolders: [Folder] = []
    
    var loadedFromCanva: Bool {
        guard let canva = self.canva else { return false }
        return CanvaService.data.contains(canva)
    }
    
    var state: State
    
    // MARK: - Hide name label or text field
    var hideNameLabel: Bool {
        switch state {
        case .visualization:
            return false
        case .editing:
            return true
        }
    }
    var hideNameTextField: Bool { !hideNameLabel }
    
    // MARK: - Collections is interactable
    var collectionIsUserInteractionEnabled: Bool {
        switch state {
        case .visualization:
            return false
        case .editing:
            return true
        }
    }
    
    var mainButtonImage: UIImage? {
        switch state {
        case .visualization:
            return UIImage(systemName: "pencil")
        case .editing:
            return UIImage(systemName: "checkmark")
        }
    }
    
    let cancelButtonImage: UIImage? = UIImage(systemName: "xmark")
    
    init(canva: Canva, state: State) {
        self.canva = canva
        self.state = state
        
        canvaService.fetch()
        clotheService.fetch()
    }
    
    init() {
        self.state = .editing
        
        canvaService.fetch()
        clotheService.fetch()
        canvaDelegate?.setupState()
    }
    
    func selectFolder(_ folder: Folder) {
        if let idx = selectedFolders.firstIndex(of: folder) {
            selectedFolders.remove(at: idx)
        } else {
            selectedFolders.append(folder)
        }
    }
    
    func toggleTag(_ tag: Tag) {
        if let idx = selectedTags.firstIndex(of: tag) {
            selectedTags.remove(at: idx)
        } else {
            selectedTags.append(tag)
        }
    }
    
    func mainButtonPressed() {
        switch state {
        case .visualization:
            self.updateState()
        case .editing:
            guard let delegate = canvaDelegate else { return }
            
            delegate.segueToSaveModal()
        }
    }
    
    func cancelButtonPressed() {
        if self.loadedFromCanva, self.canva != nil {
            self.load(self.canva!)
        } else {
            self.reset()
        }
    }

    func load(_ canva: Canva) {
        self.canva = canva
        var clothes = [(Clothe, ClotheAtCanvaPosition)]()
        canva.clothes?.forEach({ clotheAtCanva in
            guard let clotheAtCanva = clotheAtCanva as? ClotheAtCanva,
                  let data = clotheAtCanva.data() else { return }
            
            clothes.append(data)
        })
        self.state = .visualization
        canvaDelegate?.loadFromCanva(clothes: clothes)
    }
    
    func load() {
        var clothes = [(Clothe, ClotheAtCanvaPosition)]()
        canva?.clothes?.forEach({ clotheAtCanva in
            guard let clotheAtCanva = clotheAtCanva as? ClotheAtCanva,
                  let data = clotheAtCanva.data() else { return }
            
            clothes.append(data)
        })
        canvaDelegate?.loadFromCanva(clothes: clothes)
        canvaDelegate?.setupState()
    }
    
    func save() {
        let canva = self.canva ?? Canva(context: canvaService.viewContext)
        canva.name = canvaNameDelegate?.canvaName
        canva.thumbnail = canvaDelegate?.thumbnail.pngData()
        
        canva.clothes = nil
        canvaDelegate?.objects.forEach({ (view: UIView, clothe: Clothe) in
            let newClotheAtCanva = ClotheAtCanva(context: canvaService.viewContext)
            
            
            let position = ClotheAtCanvaPosition(position: view.frame, transform: view.transform)
            let encoder = JSONEncoder()
            
            newClotheAtCanva.clothe = clothe
            newClotheAtCanva.position = try? encoder.encode(position)
            
            canva.addToClothes(newClotheAtCanva)
        })
        
        for folder in selectedFolders {
            canva.addToFolders(folder)
            folder.addToCanvas(canva)
        }
        
        canvaService.update()
        updateState()
//        reset()
    }
    
    func reset() {
        self.canva = nil
        self.rollback()
        canvaDelegate?.reset()
    }
    
    func removeClotheFromCanva(_ clothe: Clothe) {
        guard let toRemove = canva?.clothes?.first(where: { ($0 as? ClotheAtCanva)?.clothe?.id == clothe.id }) as? ClotheAtCanva else { return }
        canva?.removeFromClothes(toRemove)
    }
    
    private func rollback() {
        canvaService.viewContext.rollback()
    }
    
    private func updateState() {
        switch state {
        case .visualization:
            state = .editing
        case .editing:
            state = .visualization
        }
        
        canvaDelegate?.setupState()
    }
}


protocol CanvaDelegate : AnyObject {
    var objects: [(view: UIView, clothe: Clothe)] { get set }
    var thumbnail: UIImage { get }
    
    func setupState()
    func reset()
    func segueToSaveModal()
    func loadFromCanva(clothes: [(clothe: Clothe, position: ClotheAtCanvaPosition)])
}

protocol CanvaNameDelegate : AnyObject {
    var canvaName: String? { get }
}

struct ClotheAtCanvaPosition : Codable {
    var position: CGRect
    var transform: CGAffineTransform
}

extension ClotheAtCanva {
    func data() -> (Clothe, ClotheAtCanvaPosition)? {
        guard let data = self.position,
              let clothe = self.clothe else { return nil }
        
        let decoder = JSONDecoder()
        guard let position = try? decoder.decode(ClotheAtCanvaPosition.self, from: data) else { return nil }
        
        return (clothe, position)
    }
}
