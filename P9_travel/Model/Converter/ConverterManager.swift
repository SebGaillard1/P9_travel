//
//  ChangeService.swift
//  P9_travel
//
//  Created by Sebastien Gaillard on 26/12/2021.
//

import Foundation

class ConverterManager {
    //MARK: - Singleton Pattern
    static var shared = ConverterManager()
    private init() {}
    
    //MARK: - Private properties
    private static let apiKey = "cb9d3af8ca4fc45716d10314a50abb19"
    private static let url = "http://data.fixer.io/api/latest"
    
    private var lastFetchingRatesDate: Date?
    
    private var task: URLSessionDataTask?
    private var session = URLSession(configuration: .default)
    
    //MARK: - Initializer
    init(session: URLSession) {
        self.session = session
    }
      
    //MARK: - Computed properties
    // Array of all currencies sorted alphabetically
    var currencies = [String]() {
        didSet {
            currencies = currencies.sorted(by: { $0 < $1 })
        }
    }
    
    // Dictionary of currencies with their associated rate
    var currenciesWithRates = [String: Any]() {
        didSet {
            currencies.removeAll()
            for (currency, _) in currenciesWithRates {
                currencies.append(currency)
            }
        }
    }
    
    //MARK: - Create URLRequest
    private static func createRatesRequest() -> URLRequest {
        return URLRequest(url: URL(string: "\(url)?access_key=\(apiKey)")!)
    }
    
    //MARK: - Fetching rates
    func getRates(callBack: @escaping (Bool, [String: Any]?) -> Void) {
        if areRatesAlreadyFetchedToday() { callBack(true, currenciesWithRates); return } // Si on a déja les données, on renvoies les données locales
        
        let request = ConverterManager.createRatesRequest()
        
        task?.cancel()
        task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else { callBack(false, nil); return }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { callBack(false, nil); return }
                
                guard let resultDict = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any] else { callBack(false, nil); return }

                guard let rates = resultDict["rates"] as? [String: Any] else { return }
                
                self.currenciesWithRates = rates
                
                // Setting the last fetching date as Today
                self.lastFetchingRatesDate = Date()
                
                callBack(true, rates)
            }
        }
        
        task?.resume()
    }
    
    //MARK: - Check if rates were already fetched today
    private func areRatesAlreadyFetchedToday() -> Bool {
        guard let date = lastFetchingRatesDate else { return false }
        
        if Calendar.current.isDateInToday(date) {
            return true
        } else {
            return false
        }
    }
    
    //MARK: - Convert user currency to USD
    func convert(amount: String?, from currency: String?) -> String {
        guard let amountString = amount else { return "-" }
        guard let amountDouble = Double(amountString) else { return "-" }
        
        guard let currency = currency else { return "-" }
        guard let rate = currenciesWithRates[currency] as? Double else { return "-" }
        
        let eurToUserCurrency = amountDouble * (1/rate)
        
        guard let USDRateAsDouble = currenciesWithRates["USD"] as? Double else { return "-" }
        
        let finalResult = eurToUserCurrency * USDRateAsDouble
        
        return String(format: "%.2f", finalResult)
    }
}
