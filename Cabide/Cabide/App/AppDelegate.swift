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
            
            cold.name = "Frio"
            hot.name = "Quente"
            rainy.name = "Chuva"
            sunny.name = "Ensolarado"
            events.name = "Eventos"
            formal.name = "Formal"
            casual.name = "Casual"
            party.name = "Festa"
            vacation.name = "Férias"
            sports.name = "Esportivo"
            beach.name = "Praia"
            
            let defaultTags = [cold, hot, rainy, sunny, events, formal, casual, party, vacation, sports, beach]
            for tag in defaultTags {
                tag.id = .init()
            }
            
            tagService.update()
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

