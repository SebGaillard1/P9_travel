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
    
    var currencies = [String]() {
        didSet {
            currencies = currencies.sorted(by: { $0 < $1 })
        }
    }
    
    private var currenciesWithRates = [String: Any]() {
        didSet {
            currencies.removeAll()
            for (currency, _) in currenciesWithRates {
                currencies.append(currency)
            }
        }
    }
    
    func getRates(callBack: @escaping (Bool, [String: Any]?) -> Void) {
        if lastFetchingRatesDate == nil || lastFetchingRatesDate != Date() {
            
        let request = ChangeService.createRatesRequest()
        
        task?.cancel()
        task = rateSession.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else { callBack(false, nil); return }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { callBack(false, nil); return }
                
                guard let resultDict = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any] else { callBack(false, nil); return }

                guard let rates = resultDict["rates"] as? [String: Any] else { return }
                
                self.currenciesWithRates = rates
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                //self.lastFetchingRatesDate = dateFormatter.date(from: responseJSON.date)
//                print(responseJSON.date)
//                print(self.lastFetchingRatesDate)
//                print(Date())
                
                callBack(true, rates)
            }
        }
        
        task?.resume()
        }
    }
    
    private static func createRatesRequest() -> URLRequest {
        return URLRequest(url: URL(string: "\(url)?access_key=\(apiKey)")!)
    }
    
    func convert(amount: String?, to currency: String?) -> String {
        guard let stringAmount = amount else { return "0" }
        guard let amount = Double(stringAmount) else { return "0" }
        
        guard let currency = currency else { return "0" }
        guard let rate = currenciesWithRates[currency] as? Double else { return "0" }
        
        let result = amount * rate
        
        return String(format: "%.2f", result)
    }
}
