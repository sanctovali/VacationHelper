//
//  ResultProcessingViewController.swift
//  Vacation Helper
//
//  Created by Valentin Kiselev on 9/5/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import UIKit

class ResultProcessingViewController: UIViewController {
	
	private var loadProgressView: LoadProgressView!
	
	var desiredWeather: Weather!
	
	var startDate: Date?
	var endDate: Date?
	
	var homeCity: City!
	
	lazy fileprivate var weatherManager = VacationHelperAPIManager()
	fileprivate var forecasts = [String: Weather]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupNavigationController()
		setupLoadProgressView()
		
		getVacationForecast { (isFailure) in
			if isFailure {
				showAlert(with: "There is on or more error(s)", message: "Unable to get data", actions: [AlertAction.ok.getAction()], ofType: .alert)
			}
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let vc = storyboard.instantiateViewController(identifier: ResultsViewController.storyboardIdentifier) as! ResultsViewController
			vc.home = homeCity
			vc.startDate = startDate
			vc.endDate = endDate
			vc.desiredWeather = desiredWeather
			_ = navigationController?.viewControllers.removeLast()

			navigationController?.pushViewController(vc, animated: true)
		}
    }
	
	fileprivate func setupLoadProgressView() {
		loadProgressView = LoadProgressView(frame: self.view.bounds)
		view.addSubview(loadProgressView)
	}
		
	fileprivate func setupNavigationController() {
		navigationController?.setNavigationBarHidden(true, animated: false)
	}
	
	func getVacationForecast(compleation: ( Bool) -> () ) {
		let dataController = CityDataController.shared
		var isFaliure = false
		dataController.refresh(with: NSPredicate(format: "%K == YES", #keyPath(City.isSelected)))
		var cities = dataController.getObjcs()
			cities.append(homeCity)
		cities.forEach { city in
			if getForecast(for: city) != nil {
				isFaliure = true
			}
		}
		compleation(isFaliure)
	}
	
	func getForecast(for city: City) -> Error? {		
		var error: Error?
		weatherManager.fetchWeatherForecastWith(coordinates: city.coordinates) { (result) in
			switch result {
			case .Success(let forecats):
				city.averageForecast = forecats.findAverageForecast(from: self.startDate!, to: self.endDate!)
				city.averageForecast?.calcConformationIndex(to: self.desiredWeather)
			case .Failure(let fetchError):
				error = fetchError
			}
		}
		return error
	}
 
}
