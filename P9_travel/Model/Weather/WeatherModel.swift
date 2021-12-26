//
//  WeatherModel.swift
//  P9_travel
//
//  Created by Sebastien Gaillard on 26/12/2021.
//

import Foundation

struct WeatherModel {
    let conditionID: Int
    let cityName: String
    let temperature: Double
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
        }
    
    var conditionName: String {
        switch conditionID {
        case 200 ... 232:
            return "cloud.bolt"
        case 300 ... 321:
            return "cloud.drizzle"
        case 500 ... 501:
            return "cloud.rain"
        case 502 ... 531:
            return "cloud.heavyrain"
        case 600 ... 622:
            return "cloud.snow"
        case 701:
            return "sun.haze"
        case 711:
            return "smoke"
        case 781:
            return "tornado"
        case 800:
            return "sun.max"
        case 801 ... 802:
            return "cloud.sun"
        case 803 ... 804:
            return "cloud"
        default:
            return "aqi.medium"
        }
    }

}
