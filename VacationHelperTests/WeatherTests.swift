//
//  WeatherTests.swift
//  VacationHelperTests
//
//  Created by Valentin Kiselev on 9/7/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import XCTest
@testable import Vacation_Helper

class WeatherTests: XCTestCase {
	
	func testCalcConformationIndex() {
				
		var weather1 = Weather(temperature: 25.0, precipProbability: 0.0, windSpeed: 3, icon: "", conformationIndex: nil)
		var weather2 = Weather(temperature: 43.0, precipProbability: 1.2, windSpeed: 6.2, icon: "", conformationIndex: nil)
		
		let desiredWeather = Weather(temperature: 25.0, precipProbability: 0.0, windSpeed: 3, icon: "", conformationIndex: nil)

		let fullConformance = 300
		let middleConformance = 150
		
		weather1.calcConformationIndex(to: desiredWeather)
		weather2.calcConformationIndex(to: desiredWeather)
		
		XCTAssertEqual(weather1.conformationIndex, fullConformance)
		XCTAssertEqual(weather2.conformationIndex, middleConformance)
		
	}
	
	func testWeatherParameters() {
		let weather = Weather(temperature: 25.3, precipProbability: 0.15, windSpeed: 1.69, icon: "rain", conformationIndex: nil)
		
		let extectedTempString = "25˚C"
		let extectedWindSpeedString = "2 м/с"
		let extectedPrecipProbabilityString = "15 %"
		XCTAssertNotNil(weather.temperature)
		XCTAssertNotNil(weather.precipProbability)
		XCTAssertNotNil(weather.windSpeed)
		XCTAssertNotNil(weather.icon)
		
		
		XCTAssertNotNil(weather.temperatureString)
		XCTAssertNotNil(weather.windSpeedString)
		XCTAssertNotNil(weather.precipProbabilityString)
		XCTAssertNil(weather.conformationIndex)
		
		XCTAssertEqual(weather.temperatureString, extectedTempString)
		XCTAssertEqual(weather.windSpeedString, extectedWindSpeedString)
		XCTAssertEqual(weather.precipProbabilityString, extectedPrecipProbabilityString)
		XCTAssertEqual(weather.icon, WeatherIconManager.Rain.rawValue)
		
	}
	
	func testWeatherForecastParameters() {
		let weatherForecast = WeatherForecast(date: 1599487644.0, temperature: 25.3, windSpeed: 1.69, precipProbability: 0.15, icon: "rain")
		
		let extectedTempString = "25˚C"
		let extectedWindSpeedString = "2 м/с"
		let extectedPrecipProbabilityString = "15 %"
		
		XCTAssertEqual(weatherForecast.temperatureString, extectedTempString)
		XCTAssertEqual(weatherForecast.windSpeedString, extectedWindSpeedString)
		XCTAssertEqual(weatherForecast.precipProbabilityString, extectedPrecipProbabilityString)
		XCTAssertEqual(weatherForecast.icon, WeatherIconManager.Rain.rawValue)
		XCTAssertEqual(Date(timeIntervalSince1970: weatherForecast.date), Date(timeIntervalSince1970: 1599487644.0))
		
	}
	
	func testFindAverageForecast() {
		
		let forecasts = Forecast(weatherForecasts: [WeatherForecast(date: 1599487644.0, temperature: 22.25, 											windSpeed: 1.7, precipProbability: 0.21, icon: "cloudy"),
													WeatherForecast(date: 1599426000.0, temperature: 23.5, windSpeed: 1.96, precipProbability: 0.42, icon: "rain"),
						 							WeatherForecast(date: 1599512400.0, temperature: 17.25, windSpeed: 3.69, precipProbability: 0.93, icon: "rain")
		])
		
		let averageWeather = forecasts.findAverageForecast(from: Date(timeIntervalSince1970: 1594252800.0),
														   to: Date(timeIntervalSince1970: 1599868800.0))
		
		let exteptedTemp: Float = 21.0
		let exteptedWindSpeed: Float = 2.45
		let exteptedprecipProbability: Float = 0.52
		let exteptedIcon = "rain"
		
		XCTAssertEqual(averageWeather.temperature, exteptedTemp)
		XCTAssertEqual(averageWeather.windSpeed, exteptedWindSpeed)
		XCTAssertEqual(averageWeather.precipProbability, exteptedprecipProbability)
		XCTAssertEqual(averageWeather.icon, exteptedIcon)
	}
	
	
	
}
