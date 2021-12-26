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
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    
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
                self.weatherConditionImageView.image = UIImage(systemName: weather!.conditionName)
                self.tempLabel.text = "\(weather!.temperatureString)°C"
                self.cityNameLabel.text = weather?.cityName
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
    
    private func presentErrorMessage(with error: String) {
        let ac = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(ac, animated: true)
    }
    
}
