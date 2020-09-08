//
//  AppDelegate.swift
//  Vacation Helper
//
//  Created by Valentin Kiselev on 8/31/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		return true
	}

	// MARK: UISceneSession Lifecycle
	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
	}
/*
	// MARK: - Core Data stack
	lazy var persistentContainer: NSPersistentContainer = {

	    let container = NSPersistentContainer(name: "Vacation_Helper")
	    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error {
	            fatalError("Unresolved error \(error), \(error.localizedDescription)")
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
	            let error = error as Error
	            fatalError("Unresolved error \(error), \(error.localizedDescription)")
	        }
	    }
	}
*/
}

