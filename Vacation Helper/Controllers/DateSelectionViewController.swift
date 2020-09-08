//
//  ViewController.swift
//  Vacation Helper
//
//  Created by Valentin Kiselev on 8/31/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import UIKit

protocol VacationDatesDelegate {
	func getStartDate() -> Date
	func getEndDate() -> Date
}

class DateSelectionViewController: UIViewController {
	
	static let storyboardIdentifier = String(describing: DateSelectionViewController.self)
	
	@IBOutlet weak var startDateTF: UITextField!
	@IBOutlet weak var endDateTF: UITextField!
	@IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!
	@IBOutlet weak var addCityButton: UIButton!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var emptyListLabel: UILabel!
	@IBOutlet weak var goToWeatherButton: UIButton!
	private var dobPicker = UIDatePicker()
	private var deleteButton: UIBarButtonItem!
	
	private var isInputComplete: Bool {
		get {
			return !(startDateTF.text?.isEmpty ?? true) && !(endDateTF.text?.isEmpty ?? true) && !(tableView.numberOfRows(inSection: 0) == 0)
		}
	}
		
	private let dataController = CityDataController.shared
		
	lazy var dateFormatter: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.setLocalizedDateFormatFromTemplate(DATE_FORMAT)
		return dateFormatter
	}()
	
	private var startDate = Date() {
		didSet {
			startDateTF.text = dateFormatter.string(from: dobPicker.date)
		}
	}
	private var endDate = Date() {
		didSet {
			endDateTF.text = dateFormatter.string(from: dobPicker.date)
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		subscribeToNotifications()
		setupViews()
		updateSelectedCities()

	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupNavigationBar()
		
		tableView.reloadData()
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	fileprivate func setupViews() {
	
		setupButtons()
		setupTextFields()
		setupNavigationBar()
		datePickerSetup()
		setupTableView()
	}
	
	fileprivate func setupTableView() {
		tableView.isUserInteractionEnabled = false
		tableView.delegate = self
		tableView.dataSource = self
	}
	
	fileprivate func subscribeToNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	fileprivate func setupTextFields() {
		startDateTF.delegate = self
		endDateTF.delegate = self
		startDateTF.inputView = dobPicker
		endDateTF.inputView = dobPicker
	}
	
	fileprivate func setupButtons() {
		addCityButton.setupApperance()
		addCityButton.layer.cornerRadius = addCityButton.bounds.height / 2
		addCityButton.setTitle("＋", for: [])
		goToWeatherButton.setupApperance()
		goToWeatherButton.isEnabled = false
	}
	
	fileprivate func datePickerSetup() {
		let toolbar = dobPicker.setupDatePicker()
		dobPicker.addTarget(self, action: #selector(dobPickerDateChanged(_:)), for: .valueChanged)
		let button = UIButton()
		button.setTitle("Done", for: [])
		button.setTitleColor(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), for: [])
		let doneBarButton = UIBarButtonItem(customView: button)
		button.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
		let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		toolbar.setItems([doneBarButton, spacer], animated: false)
		startDateTF.inputAccessoryView = toolbar
		endDateTF.inputAccessoryView = toolbar
	}
	
	fileprivate func setupNavigationBar() {
		navigationController?.setNavigationBarHidden(false, animated: true)
		navigationController?.navigationBar.prefersLargeTitles = false
		deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteButtonPressed))
		deleteButton.isEnabled = false
		navigationItem.title = "Едем в отпуск!"
	}
	
	@objc func deleteButtonPressed() {
		tableView.indexPathsForSelectedRows?.reversed().forEach({ (indexPath) in
			let city = dataController.getObjc(at: indexPath)
			city.isSelected = false
		})
		dataController.saveData()
		updateSelectedCities()
	}

	@objc fileprivate func keyboardWillShow(notification: NSNotification) {
		guard let info = notification.userInfo else { return }
		if let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
			
			UIView.animate(withDuration: 0.4) {
				self.textFieldBottomConstraint.constant = keyboardFrame.size.height + 20				
			}
		}
	}
	
	@objc fileprivate func keyboardWillHide(notification: NSNotification) {
		UIView.animate(withDuration: 0.4) {
			self.textFieldBottomConstraint.constant = 100
		}
	}
	
	fileprivate func updateDateSelection() {
		if startDateTF.isFirstResponder {
			startDate = dobPicker.date.startOfDay
		} else if endDateTF.isFirstResponder {
			endDate = dobPicker.date.endOfDay
		}

		goToWeatherButton.isEnabled = isInputComplete

		if startDate > endDate {
			dobPicker.date = startDate
			endDate = startDate
		}
	}	
	
	@objc private func dobPickerDateChanged(_ sender: UIDatePicker) {
		let generator = UISelectionFeedbackGenerator()
		generator.selectionChanged()
		updateDateSelection()
	}
	
	@objc private func donePressed() {
		updateDateSelection()
		view.endEditing(true)
	}
	
	@IBAction func addCity() {
		updateSelectedCities()
		if let vc = storyboard?.instantiateViewController(identifier: CityListTVC.storyboardIdentifier) as? CityListTVC {
			vc.updateDelegate = self
			vc.modalPresentationStyle = .popover
			present(vc, animated: true, completion: nil)
		}
	}
	
	@IBAction func gotoWeatherSelection() {
		if let vc = storyboard?.instantiateViewController(identifier: WeatherSelectionViewController.storyboardIdentifier) as? WeatherSelectionViewController {
			vc.vacationDatesDelegate = self
			navigationController?.pushViewController(vc, animated: true)
		}
	}
	
	fileprivate func handleDeleteButtonEnabling() {
		deleteButton.isEnabled = tableView.indexPathsForSelectedRows?.count ?? 0 > 0
	}
}

//MARK:  - UITableViewDelegate -
extension DateSelectionViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		34
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		handleDeleteButtonEnabling()
	}
	
	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		handleDeleteButtonEnabling()
	}
}

extension DateSelectionViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		dataController.objectsCount
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "selectedCityCellID", for: indexPath)
		let city = dataController.getObjc(at: indexPath)
		cell.textLabel?.text = city.name
		return cell
	}	
}

//MARK: - Editing mode -
extension DateSelectionViewController {
	override func setEditing(_ editing: Bool, animated: Bool) {
		super.setEditing(editing, animated: animated)
		
		if isEditing {
			tableView.isUserInteractionEnabled = true
			navigationItem.rightBarButtonItem = deleteButton
		} else {
			navigationItem.rightBarButtonItem = nil
			tableView.isUserInteractionEnabled = false
			tableView.deselectAll()
		}
		goToWeatherButton.isEnabled = isInputComplete
	}
}

extension DateSelectionViewController: VacationDatesDelegate {
	func getStartDate() -> Date {
		return startDate
	}
	
	func getEndDate() -> Date {
		return endDate
	}
}

extension DateSelectionViewController: UITextFieldDelegate {
	func textFieldDidBeginEditing(_ textField: UITextField) {
		switch textField {
		case startDateTF:
			dobPicker.minimumDate = Date().startOfDay
		case endDateTF:
			dobPicker.minimumDate = startDate.endOfDay
		default:
			break
		}
	}
}

extension DateSelectionViewController: SelectedCitiesDelegate {
	func updateSelectedCities() {
		dataController.refresh(with: NSPredicate(format: "%K == YES", #keyPath(City.isSelected)) )
		if dataController.objectsCount > 0 {
			emptyListLabel.isHidden = true
			navigationItem.leftBarButtonItem = editButtonItem
			
		} else {
			emptyListLabel.isHidden = false
			tableView.isEditing = false
			self.setEditing(false, animated: true)
			goToWeatherButton.isEnabled = false

			navigationItem.leftBarButtonItem = nil
			navigationItem.rightBarButtonItem = nil
		}
		tableView.reloadData()
		goToWeatherButton.isEnabled = isInputComplete
		handleDeleteButtonEnabling()
	}
}
