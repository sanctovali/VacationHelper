//
//  APIManager.swift
//  Vacation Helper
//
//  Created by Valentin Kiselev on 9/3/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import Foundation

typealias JSONTask = URLSessionDataTask
typealias JSONCompletionHandler = (Data?, HTTPURLResponse?, Error?) -> Void

protocol FinalURLPoint {
	var baseURL: URL {get}
	var path: String {get}
	var request: URLRequest {get}
	var measuringSystem: String {get}
}

enum APIResult<T> {
	case Success(T)
	case Failure(Error)
}

protocol APIManager {
	var sessionConfiguration: URLSessionConfiguration { get }
	var session: URLSession { get }
	
	func JSONTaskWith(request: URLRequest, completionHandler: @escaping JSONCompletionHandler ) -> JSONTask
	func fetch<T: Decodable>(request: URLRequest, parse: @escaping (Data) -> T?, completionHandler: @escaping (APIResult<T>) -> Void)
}

extension APIManager {
    func JSONTaskWith(request: URLRequest, completionHandler: @escaping JSONCompletionHandler) -> JSONTask {
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard let HTTPResponse = response as? HTTPURLResponse else {
				let error = VHErrorManager.missingResponce
				completionHandler(nil, nil, error)
				return
            }

            if data == nil {
                if let error = error {
                    completionHandler(nil, HTTPResponse, error)
                }
            } else {
                switch HTTPResponse.statusCode {
                case 200:
                    if let data = data {
                        completionHandler(data, nil, nil)
                    }
				case let statusCode where statusCode >= 400 && statusCode < 500:
					let error = VHErrorManager(statusCode)
					completionHandler(nil, HTTPResponse, error)
                default:
					let error = VHErrorManager.unexpectedError
					completionHandler(nil, HTTPResponse, error)
                    print("We have got response status \(HTTPResponse.statusCode)")
                }
            }
        }
        return dataTask
    }
    
    func fetch<T: Decodable>(request: URLRequest, parse: @escaping (Data) -> T?, completionHandler: @escaping (APIResult<T>) -> Void) {
        let dataTask = JSONTaskWith(request: request) {(json, _, error) in
            DispatchQueue.main.async(execute: {
				
				if let error = error {
					completionHandler(.Failure(error))
				} else {
					guard let json = json, let value = parse(json) else {
						let error = VHErrorManager.decodeFailed
						completionHandler(.Failure(error))
						return
					}
					completionHandler(.Success(value))
				}
            })
            
        }
        dataTask.resume()
    }

}

