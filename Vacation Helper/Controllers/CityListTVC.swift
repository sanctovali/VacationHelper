//
//  CityListTVC.swift
//  Vacation Helper
//
//  Created by Valentin Kiselev on 9/2/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import UIKit

protocol SelectedCitiesDelegate {
	func updateSelectedCities()
}

final class CityListTVC: UIViewController {
	
	static let storyboardIdentifier = String(describing: CityListTVC.self)
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var bgdView: UIView!
	
	private var dataController = CityDataController.shared
	
	var updateDelegate: SelectedCitiesDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
		dataController.updateQuery(with: "")
		tableView.delegate = self
		tableView.dataSource = self
		searchBar.delegate = self
		setupView()
    }
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		updateDelegate.updateSelectedCities()
	}
	
	private func setupView() {
		view.accessibilityIdentifier = "cityListView"
		self.tableView.tableFooterView = UIView(frame: .zero);
		bgdView.layer.cornerRadius = view.bounds.width * 0.06
		searchBar.layer.cornerRadius = view.bounds.width * 0.06
		searchBar.clipsToBounds = true
		bgdView.layer.shadowColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
		bgdView.layer.shadowOffset = CGSize(width: 0.0, height: -5.0)
		bgdView.layer.shadowOpacity = 0.7
		bgdView.layer.shadowRadius = 3.1
	}
}

extension CityListTVC: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 34
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		let selected = dataController.getObjc(at: indexPath)
		selected.isSelected.toggle()
		dataController.saveData()
		tableView.reloadRows(at: [indexPath], with: .automatic)
	}
	
	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

		let selected = dataController.getObjc(at: indexPath)
		selected.isSelected = false
		dataController.saveData()
		updateDelegate.updateSelectedCities()
		tableView.reloadRows(at: [indexPath], with: .automatic)
	}
	
}

extension CityListTVC: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		dataController.objectsCount
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cityNameCellID", for: indexPath)
		let city = dataController.getObjcs()[indexPath.row]
		cell.textLabel?.text = city.name
		cell.accessoryType = city.isSelected ? .checkmark : .none
		return cell
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		1
    }
	
}

extension CityListTVC: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		dataController.updateQuery(with: searchText)
		searchBar.setShowsCancelButton(!searchText.isEmpty, animated: true)
		tableView.reloadData()
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let txt = searchBar.text else {
			return
		}
		dataController.updateQuery(with: txt)
		searchBar.resignFirstResponder()
		tableView.reloadData()
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		dataController.updateQuery(with: "")
		searchBar.setShowsCancelButton(false, animated: true)
		searchBar.text = nil
		searchBar.resignFirstResponder()
		tableView.reloadData()
	}
	
}




