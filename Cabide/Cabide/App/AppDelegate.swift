//
//  AppDelegate.swift
//  Cabide
//
//  Created by Gabriel Medeiros Martins on 24/07/23.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        DispatchQueue.global(qos: .userInitiated).async {
            _ = UIImage(named: "logo")?.removeBackground()
        }
        
        if let window = window,
                   let windowScene = window.windowScene {
                    windowScene.windows.forEach { window in
                        window.tintColor = UIColor.red
                    }
                }
        
        var tagService = TagService.build()
        if TagService.data.count == 0 {
            let cold = Tag(context: DataController.shared.viewContext)
            let hot = Tag(context: DataController.shared.viewContext)
            let rainy = Tag(context: DataController.shared.viewContext)
            let sunny = Tag(context: DataController.shared.viewContext)
            let events = Tag(context: DataController.shared.viewContext)
            let formal = Tag(context: DataController.shared.viewContext)
            let casual = Tag(context: DataController.shared.viewContext)
            let party = Tag(context: DataController.shared.viewContext)
            let vacation = Tag(context: DataController.shared.viewContext)
            let sports = Tag(context: DataController.shared.viewContext)
            let beach = Tag(context: DataController.shared.viewContext)
            
            cold.name = "Frio"          // 0
            hot.name = "Quente"         // 1
            rainy.name = "Chuva"        // 2
            sunny.name = "Ensolarado"   // 3
            events.name = "Eventos"     // 4
            formal.name = "Formal"      // 5
            casual.name = "Casual"      // 6
            party.name = "Festa"        // 7
            vacation.name = "Férias"    // 8
            sports.name = "Esportivo"   // 9
            beach.name = "Praia"        // 10
            
            let defaultTags = [cold, hot, rainy, sunny, events, formal, casual, party, vacation, sports, beach]
            for tag in defaultTags {
                tag.id = .init()
            }
            
            tagService.update()
        }
        
        var clotheService = ClotheService.build()
        if ClotheService.data.count == 0 {
            var clothes = [Clothe]()
            
            let group = DispatchGroup()
            
            for idx in 1...21 {
                group.enter()
                
                let closure: () -> Void = {
                    let clothe = Clothe(context: clotheService.viewContext)
                    clothe.id = .init()
                    clothe.image = UIImage(named: "image \(idx)")?.croppedToOpaque()?.pngData()
                    clothes.append(clothe)
                    
                    group.leave()
                }
                
                Task.detached {
                    closure()
                }
            }
            
            group.notify(queue: .main) {
                clothes[0].addToTags(TagService.data[8])
                clothes[1].addToTags(TagService.data[7])
                clothes[2].addToTags(TagService.data[2])
                clothes[3].addToTags(TagService.data[6])
                clothes[4].addToTags(TagService.data[6])
                clothes[5].addToTags(TagService.data[4])
                clothes[6].addToTags(TagService.data[2])
                clothes[7].addToTags(TagService.data[3])
                clothes[8].addToTags(TagService.data[3])
                clothes[9].addToTags(TagService.data[6])
                clothes[10].addToTags(TagService.data[3])
                clothes[11].addToTags(TagService.data[0])
                clothes[12].addToTags(TagService.data[0])
                clothes[13].addToTags(TagService.data[0])
                clothes[14].addToTags(TagService.data[0])
                clothes[14].addToTags(TagService.data[2])
                clothes[15].addToTags(TagService.data[0])
                clothes[15].addToTags(TagService.data[2])
                clothes[15].addToTags(TagService.data[8])
                clothes[16].addToTags(TagService.data[6])
                clothes[16].addToTags(TagService.data[1])
                clothes[16].addToTags(TagService.data[3])
                clothes[17].addToTags(TagService.data[0])
                clothes[19].addToTags(TagService.data[6])
                clothes[19].addToTags(TagService.data[1])
                clothes[19].addToTags(TagService.data[8])
                clothes[20].addToTags(TagService.data[0])
                
                clotheService.update()
            }
            
            Thread.sleep(forTimeInterval: 5)
        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Cabide")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

