//
//  CurrentWeathre.swift
//  Vacation Helper
//
//  Created by Valentin Kiselev on 9/3/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import Foundation

struct Weather: WeatherProtocol {
	
	let temperature: Float
	let precipProbability: Float
	let windSpeed: Float
	let icon: String
	
	var conformationIndex: Int?
	
	private enum ResponseCodingKeys: String, CodingKey {
		case currently
	}
	
	private enum CodingKeys: String, CodingKey {
		case temperature, precipProbability, windSpeed, icon
	}
	
	mutating func calcConformationIndex(to weather: Weather) {
		
		let tempStep = 1 / ( abs(MIN_TEMP) + abs(MAX_TEMP) )
		let windStep = 1 / MAX_WINDSPEED
		
		let tempConformationIndex = 1 - ( fabsf(temperature - weather.temperature) * tempStep )
		let windConformationIndex = 1 - ( fabsf(windSpeed - weather.windSpeed) * windStep )
		let precipConformationIndex = 1 - fabsf(precipProbability - weather.precipProbability)
		
		conformationIndex = Int((tempConformationIndex + windConformationIndex + precipConformationIndex) * 100.0)
	}

}

extension Weather: Codable {
	
	init(from decoder: Decoder) throws {
		guard let container = try? decoder.container(keyedBy: ResponseCodingKeys.self),
			let currentWeatherContainer = try? container.nestedContainer(keyedBy: CodingKeys.self, forKey: .currently) else { let error = VHErrorManager.decodeFailed; throw error }
		
		do {
			self.temperature = try currentWeatherContainer.decode(Float.self, forKey: .temperature)
			self.windSpeed = try currentWeatherContainer.decode(Float.self, forKey: .windSpeed)
			self.precipProbability = try currentWeatherContainer.decode(Float.self, forKey: .precipProbability)
			self.icon = try currentWeatherContainer.decode(String.self, forKey: .icon)
		} catch let error {
			print("Can`t initialize CurrentWeather. There is an error \(error)")
			throw error
		}
	}

}
