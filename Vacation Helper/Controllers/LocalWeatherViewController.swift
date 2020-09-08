//
//  LocalWeatherViewController.swift
//  Vacation Helper
//
//  Created by Valentin Kiselev on 9/3/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import UIKit
import CoreLocation

class LocalWeatherViewController: UIViewController {
	
	@IBOutlet weak var locationLabel: UILabel!
	@IBOutlet weak var localPrecipitationLabel: UILabel!
	@IBOutlet weak var localWindLabel: UILabel!
	@IBOutlet weak var localTempLabel: UILabel!
	@IBOutlet weak var weatherImageView: UIImageView!
	@IBOutlet weak var contentView: UIView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	fileprivate let locationManager = CLLocationManager()
	fileprivate var userLocations = [String: CLLocation]()
	var locationString = ""
	
	lazy fileprivate var weatherManager = VacationHelperAPIManager()
	lazy private(set) var coordinates = ManagedObjectController().newEntity(of: Coordinates.self, needSave: false)

    override func viewDidLoad() {
        super.viewDidLoad()

		setupLocationManager()
		activityIndicator.hidesWhenStopped = true
		
		setupLocalWeatherView()
    }
	
	fileprivate func setupLocalWeatherView() {
		contentView.layer.cornerRadius = view.bounds.width * 0.06
		contentView.layer.masksToBounds = true
	}
	
	fileprivate func setupLocationManager() {
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestWhenInUseAuthorization()
		locationManager.startUpdatingLocation()
	}
	
	fileprivate func getCurrentWeatherData() {
		weatherManager.fetchCurrentWeatherWith(coordinates: coordinates) { (result) in
			self.toggleActivityIndicator(on: false)
			switch result {
			case .Success(let currentWeather):
				self.updateUIWith(currentWeather: currentWeather)
			case .Failure(let error as NSError):
				self.showAlert(with: "Unable to get data", message: "\(error.localizedDescription)", actions: [AlertAction.ok.getAction()], ofType: .alert)
			}
		}
	}
	
	fileprivate func updateUIWith(currentWeather: Weather) {
		self.weatherImageView.image = WeatherIconManager.init(rawValue: currentWeather.icon).image
		self.localPrecipitationLabel.text = "осадки " + currentWeather.precipProbabilityString
		self.localWindLabel.text = "ветер " + currentWeather.windSpeedString
		self.localTempLabel.text = currentWeather.temperatureString
		self.locationLabel.text = "За окном " + locationString

	}
	
	fileprivate func toggleActivityIndicator(on: Bool) {
		if on {
			activityIndicator.stopAnimating()
		} else {
			activityIndicator.stopAnimating()
		}
	}

}


extension LocalWeatherViewController: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		let userLocation = locations.last! as CLLocation
			self.userLocations["current"] = userLocation
			if let currentLocation = self.userLocations["current"] {
				self.coordinates.latitude = currentLocation.coordinate.latitude
				self.coordinates.longitude = currentLocation.coordinate.longitude

				CLGeocoder().reverseGeocodeLocation(currentLocation) { (placemarks, error) in
					if let error = error {
						print(error.localizedDescription)
					} else {
						if let placemark = placemarks?[0] {
							self.locationString = ""
							
							if placemark.subAdministrativeArea != nil {
								self.locationString += placemark.subAdministrativeArea!
							}
							if placemark.subLocality != nil {
								self.locationString += ", " + placemark.subLocality!
							}
						}
						
					}
					self.getCurrentWeatherData()
					self.locationLabel.text = self.locationString
				}
			}
	}
}
