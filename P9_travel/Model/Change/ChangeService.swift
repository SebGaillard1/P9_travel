//
//  ChangeService.swift
//  P9_travel
//
//  Created by Sebastien Gaillard on 26/12/2021.
//

import Foundation

class ChangeService {
    static var shared = ChangeService()
    private init() {}
    
    private static let apiKey = "a7841991a6a36d9a87dbcef10bb31e27"
    private static let url = "http://data.fixer.io/api/latest"
    
    private var task: URLSessionDataTask?
    
    private var rateSession = URLSession(configuration: .default)
    
    private var lastFetchingRatesDate: Date?
    
    func getRates(callBack: @escaping (Bool, Rates?) -> Void) {
        if lastFetchingRatesDate == nil || lastFetchingRatesDate != Date() {
            
        let request = ChangeService.createRatesRequest()
        
        task?.cancel()
        task = rateSession.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callBack(false, nil)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callBack(false, nil)
                    return
                }
                
                guard let responseJSON = try? JSONDecoder().decode(RateData.self, from: data)
                else {
                    callBack(false, nil)
                    return
                }
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                self.lastFetchingRatesDate = dateFormatter.date(from: responseJSON.date)
//                print(responseJSON.date)
//                print(self.lastFetchingRatesDate)
//                print(Date())
                
                let rates = responseJSON.rates
                callBack(true, rates)
            }
        }
        
        task?.resume()
        }
    }
    
    private static func createRatesRequest() -> URLRequest {
        return URLRequest(url: URL(string: "\(url)?access_key=\(apiKey)")!)
    }
}
