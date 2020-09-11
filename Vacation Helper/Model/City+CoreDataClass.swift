//
//  City+CoreDataClass.swift
//  Vacation Helper
//
//  Created by Valentin Kiselev on 9/4/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//
//

import Foundation
import CoreData


public class City: NSManagedObject, Decodable&Encodable {
	
	var averageForecast: Weather?
	
	private enum CodingKeys: String, CodingKey {
		case name = "name"
		case coordinates = "coordinates"
		case isSelected = "isSelected"
	}
	
	override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
		super.init(entity: entity, insertInto: context)
	}
	
	public required convenience init(from decoder: Decoder) throws {
		let managedObjectContext = CityDataController.shared.context
		
		guard let entity = NSEntityDescription.entity(forEntityName: "City", in: managedObjectContext) else { fatalError("Failed to Create City entity") }
		
		self.init(entity: entity, insertInto: nil)
		
		guard let container = try? decoder.container(keyedBy: CodingKeys.self) else { fatalError("There is no container") }
		do {
			isSelected = try container.decodeIfPresent(Bool.self, forKey: .isSelected) ?? false
			name = try container.decode(String.self, forKey: .name)
			coordinates = try Coordinates(from: decoder)
			
		} catch {
			throw VHErrorManager.missingResponce
		}
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		var coordinatesContainer = encoder.container(keyedBy: Coordinates.CodingKeys.self)
		do {
			try container.encode(name, forKey: .name)
			try container.encode(isSelected, forKey: .isSelected)
			try coordinatesContainer.encode(coordinates.latitude, forKey: .latitude)
			try coordinatesContainer.encode(coordinates.longitude, forKey: .longitude)
		} catch {
			throw VHErrorManager.decodeFailed
		}
	}
	
}
