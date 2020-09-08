//
//  WeatherIconManager.swift
//  Vacation Helper
//
//  Created by Valentin Kiselev on 9/3/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import UIKit

enum WeatherIconManager: String {
	case ClearDay = "clear-day"
	case ClearNight = "clear-night"
	case Rain = "rain"
	case Snow = "snow"
	case Sleet = "sleet"
	case Wind = "wind"
	case Fob = "fog"
	case Cloudy = "cloudy"
	case PartlyCloudyDay = "partly-cloudy-day"
	case PartlyCloudyNight = "partly-cloudy-night"
	case Hail = "hail"
	case Thunderstorm = "thunderstorm"
	case Yornado = "tornado"
	case UnpredictedIcon = "unpredicted-icon"
	
	init(rawValue: String) {
		switch rawValue {
		case "clear-day": self = .ClearDay
		case "clear-night": self = .ClearNight
		case "rain": self = .Rain
		case "snow": self = .Snow
		case "sleet": self = .Sleet
		case "wind": self = .Wind
		case "fog": self = .Fob
		case "cloudy": self = .Cloudy
		case "partly-cloudy-day": self = .PartlyCloudyDay
		case "partly-cloudy-night": self = .PartlyCloudyNight
		case "hail": self = .Hail
		case "thunderstorm": self = .Thunderstorm
		case "tornado": self = .Thunderstorm
			
		default: self = .UnpredictedIcon
		}
	}
}

extension WeatherIconManager {
	var image: UIImage {
		return UIImage(named: self.rawValue)!
	}
}

