//
//  NetworkLayerTests.swift
//  VacationHelperTests
//
//  Created by Valentin Kiselev on 9/7/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import XCTest
@testable import Vacation_Helper

class NetworkLayerTests: XCTestCase {
	
	func testMakingRequests() {
		
		let coordinates = ManagedObjectController().newEntity(of: Coordinates.self, needSave: false)
		
		let currentWeatherRequest = ForecastType.Current(apiKey: API_KEY, coordinates: coordinates).request
		let weatherForecastRequest = ForecastType.Forecast(apiKey: API_KEY, coordinates: coordinates).request
		
		let scheme = "https"
		
		let currentWeatherRequestPath = "/forecast/\(API_KEY)/\(coordinates.latitude),\(coordinates.longitude)"
		let weatherForecastRequestPath = "/forecast/\(API_KEY)/\(coordinates.latitude),\(coordinates.longitude)"
		
		let baseURL = "api.forecast.io"

		XCTAssertTrue(currentWeatherRequest.url?.scheme == scheme, "currentWeatherRequest scheme must be \(scheme)")
		XCTAssertTrue(weatherForecastRequest.url?.scheme == scheme, "weatherForecastRequest scheme must be \(scheme)")

		XCTAssertTrue(currentWeatherRequest.url?.path == currentWeatherRequestPath, "currentWeatherRequest path must be \(currentWeatherRequestPath)")
		XCTAssertTrue(weatherForecastRequest.url?.path == weatherForecastRequestPath, "weatherForecastRequest path must be \(weatherForecastRequestPath)")
		
		XCTAssertTrue(weatherForecastRequest.url?.host == baseURL, "weatherForecastRequest path must be \(baseURL)")
		XCTAssertTrue(weatherForecastRequest.url?.host == baseURL, "weatherForecastRequest path must be \(baseURL)")
		
	}
	
	func testParsingResponse() {
		
		let mockData = "{\"currently\": {\"time\": 1599487644,\"icon\": \"cloudy\",\"precipProbability\": 0.21,\"temperature\": 22.08,\"windSpeed\": 1.69,\"windGust\": 2.22},\"daily\": {\"data\": [{\"time\": 1599426000,\"icon\": \"rain\",\"precipProbability\": 0.42,\"temperatureHigh\": 23.97,\"windSpeed\": 1.96,\"temperatureMax\": 23.97}]}}".data(using: .utf8)!
		
		let decodedWeather = try? JSONDecoder().decode(Weather.self, from: mockData)
		let decodedForecast = try? JSONDecoder().decode(Forecast.self, from: mockData)
		
		XCTAssertNotNil(decodedWeather)
		XCTAssertNotNil(decodedForecast)
	
	}
	
	func testAPIRequests() {
		let apiManager = VacationHelperAPIManager()
		let coordinates = ManagedObjectController().newEntity(of: Coordinates.self, needSave: false)
		coordinates.latitude = 55.7
		coordinates.longitude = 37.9
		
		let promise1 = expectation(description: "Propper Response come")
		let promise2 = expectation(description: "Propper Response come")
		
		var weather: Weather?
		var forecast: Forecast?
		
		apiManager.fetchCurrentWeatherWith(coordinates: coordinates) { (result) in
			switch result {
			case .Success(let weatherResponse):
				weather = weatherResponse
				promise1.fulfill()
			case .Failure(_ ):
				XCTFail()
			}
		}
		
		apiManager.fetchWeatherForecastWith(coordinates: coordinates) { (result) in
			switch result {
			case .Success(let forecastResponse):
				forecast = forecastResponse
				promise2.fulfill()
			case .Failure( _ ):
				XCTFail()
			}
		}
		
		wait(for: [promise1, promise2], timeout: 5)
		
		XCTAssertNotNil(weather)
		XCTAssertNotNil(forecast)
		
	}

}
