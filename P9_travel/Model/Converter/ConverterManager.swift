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
    private let apiKey = "a7841991a6a36d9a87dbcef10bb31e27"
    private let url = "http://data.fixer.io/api/latest"
    
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
    
    //MARK: - Alert Notification
    private func alertNotification(message: String) {
        let alertName = Notification.Name("alert")
        NotificationCenter.default.post(name: alertName, object: nil, userInfo: ["message": message])
    }
    
    //MARK: - Public methods
    //Fetching rates
    func getRates(callBack: @escaping (Bool, [String: Any]?) -> Void) {
        if areRatesAlreadyFetchedToday() { callBack(true, currenciesWithRates); return }
        
        let request = createRatesRequest()
        
        task?.cancel()
        task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    self.alertNotification(message: "Failed to fetch rates!")
                    callBack(false, nil)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    self.alertNotification(message: "Bad server response, cannot fetch rates!")
                    callBack(false, nil)
                    return
                }
                
                guard let resultDict = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any] else {
                    self.alertNotification(message: "Failed to decode data!")
                    callBack(false, nil)
                    return
                }

                guard let rates = resultDict["rates"] as? [String: Any] else {
                    self.alertNotification(message: "Failed to decode data!")
                    return
                }
                
                self.currenciesWithRates = rates
                
                // Setting the last fetching date as current date
                self.lastFetchingRatesDate = Date()
                
                callBack(true, rates)
            }
        }
        
        task?.resume()
    }
    
    // Convert user currency to USD
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
    
    //MARK: - Private methods
    // Create URLRequest object
    private func createRatesRequest() -> URLRequest {
        return URLRequest(url: URL(string: "\(url)?access_key=\(apiKey)")!)
    }
    
    // Check if rates were already fetched today
    private func areRatesAlreadyFetchedToday() -> Bool {
        guard let date = lastFetchingRatesDate else { return false }
        
        if Calendar.current.isDateInToday(date) {
            return true
        } else {
            return false
        }
    }
}
