//
//  WeatherSelectionViewController.swift
//  Vacation Helper
//
//  Created by Valentin Kiselev on 9/3/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import UIKit

class WeatherSelectionViewController: UIViewController {
	
	static let storyboardIdentifier = String(describing: WeatherSelectionViewController.self)

	@IBOutlet weak var precipitationLabel: UILabel!
	@IBOutlet weak var windLabel: UILabel!
	@IBOutlet weak var tempLabel: UILabel!
	@IBOutlet weak var goToResultsButton: UIButton!
	@IBOutlet weak var temperatureSlider: UISlider!
	@IBOutlet weak var precipitationSlider: UISlider!
	@IBOutlet weak var windSpeedSlider: UISlider!
	@IBOutlet weak var localWeatherView: UIView!

	private var localWeatherViewController: LocalWeatherViewController!
	var vacationDatesDelegate: VacationDatesDelegate!
	
	var desiredWeather: Weather!

	override func viewDidLoad() {
        super.viewDidLoad()
		setupViews()
		loadWeatherController()
		setupNavigationBar()
    }

	fileprivate func setupViews() {
		goToResultsButton.setupApperance()
		setupLocalWeatherView()
		setupSliders()
		setupLabels()
	}
	
	fileprivate func loadWeatherController() {
		guard let weatherController = children.first as? LocalWeatherViewController else  {
		  fatalError("Check storyboard for missing LocalWeatherViewController")
		}
		localWeatherViewController = weatherController
	}
	

	fileprivate func setupLocalWeatherView() {
		localWeatherView.layer.cornerRadius = view.bounds.width * 0.06
		localWeatherView.layer.shadowColor = #colorLiteral(red: 0.4997962402, green: 0.6756744491, blue: 0.8326459391, alpha: 1)
		localWeatherView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
		localWeatherView.layer.shadowOpacity = 0.7
		localWeatherView.layer.shadowRadius = 9.1
	}
	
	fileprivate func setupLabels() {
		tempLabel.text = "температура " + floatValueFormatter(desiredWeather.temperature) + "˚C,"
		precipitationLabel.text = "вероятность осадков " + floatValueFormatter(desiredWeather.precipProbability * 100) + "%"
		windLabel.text = "а ветер " + floatValueFormatter(desiredWeather.windSpeed) + " м/с,"
	}
	
	fileprivate func floatValueFormatter(_ value: Float) -> String {
		return String(format: "%.f", value)
	}

	
	fileprivate func setupSliders() {
		temperatureSlider.minimumValue = MIN_TEMP
		temperatureSlider.maximumValue = MAX_TEMP
		temperatureSlider.value = 23.0
		windSpeedSlider.minimumValue = MIN_WINDSPEED
		windSpeedSlider.maximumValue = MAX_WINDSPEED
		windSpeedSlider.value = 2
		precipitationSlider.minimumValue = 0.0
		precipitationSlider.maximumValue = 1.0
		precipitationSlider.value = 0.0
		desiredWeather = Weather(temperature: temperatureSlider.value,
									precipProbability: precipitationSlider.value,
									windSpeed: windSpeedSlider.value,
									icon: WeatherIconManager.UnpredictedIcon.rawValue)
	}
    
	fileprivate func setupNavigationBar() {
		navigationItem.title = "Выберите параметры погоды"
		navigationController?.navigationBar.prefersLargeTitles = false
	}
	
	fileprivate func navigateToResultProcessingViewController() {
		navigationController?.pushViewController(prepareResultProcessingViewController(), animated: true)
	}

	
	fileprivate func prepareResultProcessingViewController() -> ResultProcessingViewController {
		let vc = ResultProcessingViewController()
		let dataController = ManagedObjectController()
		let homeCity = dataController.newEntity(of: City.self, needSave: false)
		homeCity.name = localWeatherViewController.locationString
		homeCity.coordinates = localWeatherViewController.coordinates
		vc.homeCity = homeCity
		vc.desiredWeather = desiredWeather
		vc.endDate = vacationDatesDelegate.getEndDate()
		vc.startDate = vacationDatesDelegate.getStartDate()
		return vc
	}
	
	@IBAction func calcResults() {
		navigateToResultProcessingViewController()
	}
	
	
	
	@IBAction func valueChanged(_ sender: UISlider) {
		print(sender.value)
		desiredWeather = Weather(temperature: temperatureSlider.value,
									precipProbability: precipitationSlider.value,
									windSpeed: windSpeedSlider.value,
									icon: WeatherIconManager.UnpredictedIcon.rawValue)
		setupLabels()
	}

}


