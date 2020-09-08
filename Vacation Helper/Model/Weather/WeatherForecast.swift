//
//  WeatherForecast.swift
//  Vacation Helper
//
//  Created by Valentin Kiselev on 9/3/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import Foundation

struct WeatherForecast: Codable, WeatherProtocol {
	let date: Double
	let temperature: Float
	let windSpeed: Float
	let precipProbability: Float
	let icon: String//UIImage
	
	
	private enum CodingKeys: String, CodingKey {
		case date = "time"
		case temperature = "temperatureHigh"
		case windSpeed, precipProbability, icon
	}
}

struct Forecast {
	let weatherForecasts: [WeatherForecast]
	
	private enum ForecastResponceCodingKeys: String, CodingKey {
		case daily
	}
	
	private enum CodingKeys: String, CodingKey {
		case weatherForecasts = "data"
	}
		
	func findAverageForecast(from startDate: Date, to endDate: Date) -> Weather {
		let conformedForecasts = weatherForecasts.filter { Date(timeIntervalSince1970: $0.date).isBetween(startDate, and: endDate) }
		let forecastsCount = Float(conformedForecasts.count)
		// weatherForecast.date at least 1 time is between startDate && endDate
		let averageTemp = ( conformedForecasts.reduce(0) { $0 + $1.temperature } ) / forecastsCount
		let averageWindSpeed = ( conformedForecasts.reduce(0) { $0 + $1.windSpeed } ) / forecastsCount
		let averagePrecipitations = ( conformedForecasts.reduce(0) { $0 + $1.precipProbability } ) / forecastsCount
		
		print( averagePrecipitations )
		let icons = conformedForecasts.map {$0.icon}
		
		return Weather(temperature: averageTemp,
								precipProbability: averagePrecipitations,
								windSpeed: averageWindSpeed,
								icon: icons.getMostFrequentElement() ?? WeatherIconManager.UnpredictedIcon.rawValue)
	}
}

extension Forecast: Codable {
	init(from decoder: Decoder) throws {
		guard let container = try? decoder.container(keyedBy: ForecastResponceCodingKeys.self),
			let weatherForecastContainer = try? container.nestedContainer(keyedBy: CodingKeys.self, forKey: .daily)
			 else { let error = VHErrorManager.decodeFailed; throw error }
		do {
			let forecast = try weatherForecastContainer.decode([WeatherForecast].self, forKey: .weatherForecasts)
			self.weatherForecasts = forecast
		} catch let error {
			print("Can`t initialize Forecast. There is an error \(error)")
			throw error
		}

	}
}
