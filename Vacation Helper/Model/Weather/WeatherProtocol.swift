//
//  WeatherProtocol.swift
//  Vacation Helper
//
//  Created by Valentin Kiselev on 9/3/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import Foundation

protocol WeatherProtocol {
	var temperature: Float { get }
	var windSpeed: Float { get }
	var precipProbability: Float { get }
	var icon: String { get }
	
	var temperatureString: String { get }
	var windSpeedString: String { get }
	var precipProbabilityString: String { get }
}

extension WeatherProtocol {
	var temperatureString: String {
		return String(format: "%.f", temperature) + "˚C"
	}
	var windSpeedString: String {
		return "\(Int(windSpeed.rounded())) м/с"
	}
	var precipProbabilityString: String {
		return "\(Int(precipProbability * 100)) %"
	}
}
