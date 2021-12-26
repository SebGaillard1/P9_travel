//
//  WeatherManager.swift
//  P9_travel
//
//  Created by Sebastien Gaillard on 26/12/2021.
//

import Foundation

class WeatherManager {
    static var shared = WeatherManager()
    private init() {}
    
    private let openWeatherApiURL = "https://api.openweathermap.org/data/2.5/weather?&units=metric&appid=4b82d7831968c1f714ed9fad3f72b620"
    
    private var task: URLSessionDataTask?
    
    private var weatherTask = URLSession(configuration: .default)
    
    //var cityName: String?
    
    func getWeather(cityName: String?, callBack: @escaping (Bool, WeatherModel?) -> Void) {
        let request = URLRequest(url: URL(string: "\(openWeatherApiURL)&q=\(cityName!)")!)
        
        task?.cancel()
        
        task = weatherTask.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callBack(false, nil)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callBack(false, nil)
                    return
                }
                
                guard let responseJSON = try? JSONDecoder().decode(WeatherData.self, from: data) else {
                    callBack(false, nil)
                    return
                }
                let id = responseJSON.weather[0].id
                let temp = responseJSON.main.temp
                let city = responseJSON.name
                
                let weather = WeatherModel(conditionID: id, cityName: city, temperature: temp)
                
                callBack(true, weather)
            }
        }
        
        task?.resume()
    }
}
