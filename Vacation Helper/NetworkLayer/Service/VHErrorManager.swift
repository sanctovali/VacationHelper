//
//  VHErrorManager.swift
//  Vacation Helper
//
//  Created by Valentin Kiselev on 9/3/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import Foundation

public enum VHErrorManager: Int, Error {
	
	case forbidden = 403
	case unauthorized = 401
	case pageNotFound = 404
	
	case missingResponce = 100
	case fetchFailed = 704
	case decodeFailed = 898
	case unexpectedError = 899
	
	public init(_ rawValue: Int) {
		self = VHErrorManager(rawValue: rawValue) ?? .unexpectedError
	}
}


extension VHErrorManager: LocalizedError {
	
	public var localizedDescription: String {
		let descriptionEnding = " oops! It seems something goes wrong. Please try again later."
		switch self {
		case .forbidden:
			return "You do not have access rights to the content. Please check your data"
		case .pageNotFound:
			return "The server can not find the requested resource" + descriptionEnding
		case .missingResponce:
			return "Missing HTTP response." + descriptionEnding
		case .decodeFailed:
			return "Date decoding failed"
		case .fetchFailed:
			return "Unable to fetch data from local table." + descriptionEnding
		default:
			return "There is some error." + descriptionEnding
		}
	}
}
