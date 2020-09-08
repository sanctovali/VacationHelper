//
//  CoreDataStack.swift
//  Vacation Helper
//
//  Created by Valentin Kiselev on 9/7/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import Foundation
import CoreData

open class CoreDataStack {
	public static let modelName = "Vacation_Helper"
	public static let model: NSManagedObjectModel = {
		let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd")!
		return NSManagedObjectModel(contentsOf: modelURL)!
	}()
	
	public init() {}
	
	public lazy var mainContext: NSManagedObjectContext = {
		return storeContainer.viewContext
	}()
	
	public lazy var storeContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: CoreDataStack.modelName, managedObjectModel: CoreDataStack.model)
		container.loadPersistentStores { _, error in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		}
		return container
	}()
	
	public func saveContext() {
		mainContext.perform {
			do {
				try self.mainContext.save()
			} catch let error as NSError {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		}
	}

}

