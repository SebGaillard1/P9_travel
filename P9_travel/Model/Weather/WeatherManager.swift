//
//  WeatherManager.swift
//  P9_travel
//
//  Created by Sebastien Gaillard on 26/12/2021.
//

import Foundation

class WeatherManager {
    //MARK: - Singleton Pattern
    static var shared = WeatherManager()
    private init() {}
    
    //MARK: - Properties
    private let openWeatherApiURL = "https://api.openweathermap.org/data/2.5/weather?&units=metric"
    private let apiKey = "4b82d7831968c1f714ed9fad3f72b620"
    
    private var task: URLSessionDataTask?
    private var session = URLSession(configuration: .default)
    
    //MARK: - Initializer
    init(session: URLSession) {
        self.session = session
    }
        
    //MARK: - Create URLRequest
    private func createWeatherRequest(for city: String?) -> URLRequest {
        return URLRequest(url: URL(string: "\(openWeatherApiURL)&appid=\(apiKey)&q=\(format(cityName: city))") ?? URL(string: "\(openWeatherApiURL)&q=\("")")!)
    }
    
    //MARK: - Fetching weather and create WeatherModel object
    func getWeather(for city: String?, callBack: @escaping (Bool, WeatherModel?) -> Void) {
        let request = createWeatherRequest(for: city)
        
        task?.cancel()
        task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else { callBack(false, nil); return }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { callBack(false, nil); return }
                
                guard let responseJSON = try? JSONDecoder().decode(WeatherData.self, from: data) else { callBack(false, nil); return }
                
                let id = responseJSON.weather[0].id
                let temp = responseJSON.main.temp
                let city = responseJSON.name
                let tempMax = responseJSON.main.temp_max
                let tempMin = responseJSON.main.temp_min
                let pressure = responseJSON.main.pressure
                let humidity = responseJSON.main.humidity
                let condition = responseJSON.weather[0].main
                let description = responseJSON.weather[0].description
                
                let weather = WeatherModel(conditionID: id, cityName: city, temperature: temp, tempMin: tempMin, tempMax: tempMax, pressure: pressure, humidity: humidity, condition: condition, description: description)
                
                callBack(true, weather)
            }
        }
        
        task?.resume()
    }
    
    //MARK: - Format city name with whitespace
    private func format(cityName: String?) -> String {
        guard let name = cityName else { return "" }
        let arrayOfString = name.condenseWhitespace().components(separatedBy: " ")
        var backToString = arrayOfString.joined(separator: "+")
        backToString = backToString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return backToString
    }
}
