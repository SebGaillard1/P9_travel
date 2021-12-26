//
//  WeatherViewController.swift
//  P9_travel
//
//  Created by Sebastien Gaillard on 26/12/2021.
//

import UIKit

class WeatherViewController: UIViewController {
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var weatherConditionImageView: UIImageView!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var NYWeatherContitionImageView: UIImageView!
    @IBOutlet weak var NYTempLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNewYorkWeather()
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        cityNameTextField.endEditing(true)
        
        getWeather()
    }
    
    private func getWeather() {
        WeatherManager.shared.getWeather(cityName: cityNameTextField.text) { success, weather in
            if success {
                // On affiche les données météo
                self.updateWeatherViews(with: weather!)
            } else {
                self.presentErrorMessage(with: "Failed to fetch weather")
            }
        }
    }
    
    private func getNewYorkWeather() {
        WeatherManager.shared.getWeather(cityName: "New+York") { success, NYWeather in
            if success {
                self.NYWeatherContitionImageView.image = UIImage(systemName: NYWeather!.conditionName)
                self.NYTempLabel.text = "\(NYWeather!.temperatureString)°C"
            } else {
                self.presentErrorMessage(with: "Failed to fetch New York weather")
            }
        }
    }
    
    private func updateWeatherViews(with weather: WeatherModel) {
        self.weatherConditionImageView.image = UIImage(systemName: weather.conditionName)
        self.tempLabel.text = "🌡 \(weather.temperatureString)°C"
        self.cityNameLabel.text = "🌆 \(weather.cityName)"
        self.conditionLabel.text = "🌞 \(weather.condition)"
        self.descriptionLabel.text = "ℹ️ \(weather.description)"
        self.tempMinLabel.text = "⬇ \(weather.tempMin)°C"
        self.tempMaxLabel.text = "⬆ \(weather.tempMax)°C"
        self.pressureLabel.text = "🔄 \(weather.pressure) hPa"
        self.humidityLabel.text = "💧 \(weather.humidity) %"
    }
    
    private func presentErrorMessage(with error: String) {
        let ac = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(ac, animated: true)
    }
}
