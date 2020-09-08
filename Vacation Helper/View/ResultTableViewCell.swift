//
//  ResultTableViewCell.swift
//  Vacation Helper
//
//  Created by Valentin Kiselev on 9/4/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
	
	static let cellIdentifier = String(describing: ResultTableViewCell.self)
	
	@IBOutlet weak var cityNameLabel: UILabel!
	@IBOutlet weak var startDateLabel: UILabel!
	@IBOutlet weak var endDateLabel: UILabel!
	@IBOutlet weak var windSpeedLabel: UILabel!
	@IBOutlet weak var temperatureLabel: UILabel!
	@IBOutlet weak var precipitationLabel: UILabel!
	@IBOutlet weak var iconImageView: UIImageView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
    }
	
	func setupHeader(with weather: Weather, for title: String, startDate: String?, endDate: String?) {
		cityNameLabel.text = title
		startDateLabel.text = (startDate ?? "") + "-"
		endDateLabel.text = endDate ?? ""
		windSpeedLabel.text = weather.windSpeedString
		temperatureLabel.text = weather.temperatureString
		precipitationLabel.text = weather.precipProbabilityString
		contentView.backgroundColor = #colorLiteral(red: 0.7515175167, green: 0.8980813847, blue: 1, alpha: 1)
	}
	
	func setupCell(with weather: Weather, for city: String) {
		cityNameLabel.text = city
		startDateLabel.text = ""
		endDateLabel.text = ""
		windSpeedLabel.text = weather.windSpeedString
		temperatureLabel.text = weather.temperatureString
		precipitationLabel.text = "осадки " + weather.precipProbabilityString
		iconImageView.image = WeatherIconManager.init(rawValue: weather.icon).image
		contentView.backgroundColor = #colorLiteral(red: 0.7515175167, green: 0.8980813847, blue: 1, alpha: 1)
	}
	
	
	

    
}
