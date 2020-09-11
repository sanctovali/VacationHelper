//
//  ResultsViewController.swift
//  Vacation Helper
//
//  Created by Valentin Kiselev on 9/4/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import UIKit

class ResultsViewController: UITableViewController {
	
	static let storyboardIdentifier = String(describing: ResultsViewController.self)
	
	var exportButton: UIBarButtonItem!
	
	var startDate: Date?
	var endDate: Date?
	
	private var delegate: VacationDatesDelegate?

	var desiredWeather: Weather!
	let cities = CityDataController.shared.getObjcs()
	var home: City!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTableView()
		setupNavigationBar()	
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
			self.tableView.reloadData()
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	fileprivate func setupTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		registerTableViewCells()
	}
	
	fileprivate func setupNavigationBar() {
		navigationItem.title = ""
		navigationController?.setNavigationBarHidden(false, animated: false)
		exportButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(exportButtonTapped))
		navigationItem.rightBarButtonItem = exportButton
	}
	
	fileprivate func registerTableViewCells() {
		let cell = UINib(nibName: ResultTableViewCell.cellIdentifier,
						 bundle: nil)
		tableView.register(cell,
						   forCellReuseIdentifier: ResultTableViewCell.cellIdentifier)
	}
	
	@objc func exportButtonTapped() {

		if let fileURL =  CitiesDataProvider.generateExportFile(for: cities) {
			let controller = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
			present(controller, animated: true)
		} else {
			print("There is error in \(#function) at line \(#line)")
		}
			
	}

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 80
	}
	
	override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		
		guard let weather = home.averageForecast else { return UIView() }
		let cell = tableView.dequeueReusableCell(withIdentifier: ResultTableViewCell.cellIdentifier) as! ResultTableViewCell		
		cell.setupCell(with: weather, for: "Дома: \(home.name)" )

		cell.contentView.backgroundColor = #colorLiteral(red: 0.4997962402, green: 0.6756744491, blue: 0.8326459391, alpha: 1)
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: ResultTableViewCell.cellIdentifier) as! ResultTableViewCell
		
		cell.setupHeader(with: desiredWeather, for: "Вы искали:", startDate: startDate?.getFormattedDate(), endDate: endDate?.getFormattedDate())
		cell.contentView.backgroundColor = #colorLiteral(red: 0.4997962402, green: 0.6756744491, blue: 0.8326459391, alpha: 1)
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		80
	}
	
	override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		80
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		cities.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: ResultTableViewCell.cellIdentifier, for: indexPath) as! ResultTableViewCell
		
		let city = cities.sorted { $0.averageForecast?.conformationIndex ?? 0 > $1.averageForecast?.conformationIndex ?? 0 }[indexPath.row]
		if let weather = city.averageForecast {
			cell.setupCell(with: weather, for: city.name)
		}
				
		return cell
	}
		
}
