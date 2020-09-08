//
//  VacationHalperAPIManager.swift
//  Vacation Helper
//
//  Created by Valentin Kiselev on 9/3/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import Foundation


final class VacationHelperAPIManager: APIManager {

	let sessionConfiguration: URLSessionConfiguration
	lazy var session: URLSession = {
		return URLSession(configuration: self.sessionConfiguration)
	} ()
		
	init(sessionConfiguration: URLSessionConfiguration) {
		self.sessionConfiguration = sessionConfiguration
	}
	
	convenience init() {
		self.init(sessionConfiguration: URLSessionConfiguration.default)
	}
	
	func fetchCurrentWeatherWith(coordinates: Coordinates,
								 completionHandler: @escaping (APIResult<Weather>) -> Void) {
		let request = ForecastType.Current(apiKey: API_KEY, coordinates: coordinates).request
		fetch(request: request, parse: { (data) -> Weather? in
			self.parse(data)
		}, completionHandler: completionHandler)
	}
	
	func fetchWeatherForecastWith(coordinates: Coordinates,
								 completionHandler: @escaping (APIResult<Forecast>) -> Void) {
		let request = ForecastType.Forecast(apiKey: API_KEY, coordinates: coordinates).request
		
		fetch(request: request, parse: { (data) -> Forecast? in
			self.parse(data)
			
		}, completionHandler: completionHandler)
	}
	
	func parse<T: Codable>(_ data: Data) -> T? {
		do {
			let decodedData = try JSONDecoder().decode(T.self, from: data)
			return decodedData
		} catch let error {
			print("Error at \(#function) in line \(#line): \(error.localizedDescription)")
			return nil
		}
	}

}


enum ForecastType: FinalURLPoint {
	case Current(apiKey: String, coordinates: Coordinates)
	case Forecast(apiKey: String, coordinates: Coordinates)
	
	var measuringSystem: String {
		return "si"
	}
	var baseURL: URL {
		return URL(string: "https://api.forecast.io")!
	}
	
	private var commonExclude: String{
		return "description,flags,hourly"
	}
	
	var path: String {
		switch self {
		case .Current(let apiKey, let coordinates):
			let path = "/forecast/\(apiKey)/\(coordinates.latitude),\(coordinates.longitude)?units=\(measuringSystem)&exclude=\(commonExclude),daily"
			
			return path
			
		case .Forecast(let apiKey, let coordinates):
			let path = "/forecast/\(apiKey)/\(coordinates.latitude),\(coordinates.longitude)?units=\(measuringSystem)&exclude=\(commonExclude),currently"
			
			return path
		}
	}
	var request: URLRequest {
		let url = URL(string: path, relativeTo: baseURL)
		return URLRequest(url: url!)
	}
}

