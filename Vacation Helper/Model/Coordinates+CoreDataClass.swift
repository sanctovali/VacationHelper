//
//  Coordinates+CoreDataClass.swift
//  Vacation Helper
//
//  Created by Valentin Kiselev on 9/4/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//
//

import Foundation
import CoreData

extension CodingUserInfoKey {
	static let context = CodingUserInfoKey(rawValue: "context")
}

public class Coordinates: NSManagedObject, Codable {
	
	enum CodingKeys: String, CodingKey {
		case latitude, longitude
	}
	
	public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
		super.init(entity: entity, insertInto: context)
	}
	
	public convenience required init(from decoder: Decoder) throws {
		
		let managedObjectContext = CityDataController.shared.context
		guard let entity = NSEntityDescription.entity(forEntityName: "Coordinates", in: managedObjectContext) else { fatalError("Failed to Create Coordinate entity") }
		
		
		self.init(entity: entity, insertInto: nil)
		guard let container = try? decoder.container(keyedBy: CodingKeys.self) else { fatalError("There is no container") }
		do {
			latitude = try container.decode(Double.self, forKey: .latitude)
			longitude = try container.decode(Double.self, forKey: .longitude)
		} catch {
			throw VHErrorManager.decodeFailed
		}
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		do {
			try container.encode(latitude, forKey: .latitude)
			try container.encode(longitude, forKey: .longitude)
		} catch {
			throw VHErrorManager.decodeFailed
		}
	}
}
