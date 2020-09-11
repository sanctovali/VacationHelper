//
//  ManagedObjectController.swift
//  Vacation Helper
//
//  Created by Valentin Kiselev on 9/4/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import UIKit
import CoreData

class ManagedObjectController {
	// MARK: - Properties
	
	let context: NSManagedObjectContext
	let coreDataStack: CoreDataStack
	
	
	init(with conext: NSManagedObjectContext, coreDataStack: CoreDataStack) {
		self.coreDataStack = coreDataStack
		self.context = conext
		let plistDecoderForArticle = PropertyListDecoder()
		plistDecoderForArticle.userInfo[CodingUserInfoKey.context!] = context
	}
	
	convenience init() {
		let coreDataStack = CoreDataStack()
		self.init(with: coreDataStack.mainContext, coreDataStack: coreDataStack)
	}

	
	@discardableResult
	func newEntity<T: NSManagedObject>(of type: T.Type, needSave: Bool = true) -> T {
		return T(entity: T.entity(), insertInto: needSave ? context : nil)
	}
	
	func deleteEntites<T: NSManagedObject>(_ objects: [T]) {
		objects.forEach { context.delete($0) }
		coreDataStack.saveContext()
	}
	
	func saveData() {
		print(#function)
		coreDataStack.saveContext()
	}
}

//MARK: - CityDataController -
final class CityDataController: ManagedObjectController {
	
	static let shared = CityDataController()
	
	private var fetchedRC: NSFetchedResultsController<City>!
	private var query = "" {
		didSet {
			refresh()
		}
	}
	
	private init() {
		let coreDataStack = CoreDataStack()
		super.init(with: coreDataStack.mainContext, coreDataStack: coreDataStack)
		refresh()
	}
	
	var objectsCount: Int {
		if let objects = fetchedRC.fetchedObjects {
			return objects.count
		}
		return 0
	}
	
	@discardableResult
	func getObjcs() -> [City] {
		if let objects = fetchedRC.sections?[0].objects as? [City] {
			return objects
		} else {
			return []
		}
	}
	
	@discardableResult
	func getObjc(at indexPath: IndexPath) -> City {
		return fetchedRC.object(at: indexPath)
	}
	
	func updateQuery(with value: String) {
		query = value
		refresh()
	}
	
	func refresh(with predicate: NSPredicate? = nil) {
		let request = City.fetchRequest() as NSFetchRequest<City>
		if !query.isEmpty && predicate == nil {
			request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", query)
		} else if let predicate = predicate {
			request.predicate = predicate
		}
		
		let sort = NSSortDescriptor(key: #keyPath(City.name), ascending: true)
		let isSelected = NSSortDescriptor(key: #keyPath(City.isSelected), ascending: false )
		request.sortDescriptors = [isSelected, sort]
		do {
			fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
			try fetchedRC.performFetch()
		} catch let error {
			print("Could not fetch \(error), \(error.localizedDescription)")
		}
	}
	
	override func saveData() {
		super.saveData()
		refresh()
	}
		
}
