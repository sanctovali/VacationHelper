//
//  StartViewController.swift
//  Vacation Helper
//
//  Created by Valentin Kiselev on 9/4/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
	
	private var loadProgressView: LoadProgressView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupNavigationController()
		
		initialDataCheck()
		setupLoadProgressView()
	}

	fileprivate func setupLoadProgressView() {
		loadProgressView = LoadProgressView(frame: self.view.bounds)
		view.addSubview(loadProgressView)		
	}
	
	fileprivate func setupNavigationController() {
		navigationController?.setNavigationBarHidden(true, animated: false)
	}
	
	fileprivate func loadVacationParametersController(isNeedMoreTime: Bool) {
		DispatchQueue.main.asyncAfter(deadline: .now() + (isNeedMoreTime ? 0.8 : 0.5) ) {
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let vc = storyboard.instantiateViewController(identifier: DateSelectionViewController.storyboardIdentifier)
			self.navigationController?.navigationBar.prefersLargeTitles = true
			self.navigationController?.setViewControllers([vc], animated: true)
		}
	}
	
	
	fileprivate func initialDataCheck() {
		let dataController = CityDataController.shared
		DispatchQueue.main.async {
			if dataController.objectsCount == 0 {
				CitiesDataProvider.loadData(to: dataController)
				self.loadVacationParametersController(isNeedMoreTime: true)
				
			} else {
				self.loadVacationParametersController(isNeedMoreTime: false)
			}
		}
	}
}




