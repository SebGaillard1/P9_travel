//
//  WeatherViewController.swift
//  P9_travel
//
//  Created by Sebastien Gaillard on 26/12/2021.
//

import UIKit

class WeatherViewController: UIViewController {
    //MARK: - Weather IBOutlets
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
    
    @IBOutlet var weatherViewsToHide: [UIStackView]!
    @IBOutlet weak var searchWeatherLabel: UILabel!
    
    //MARK: - NY IBOutlets
    @IBOutlet weak var nyWeatherConditionImageView: UIImageView!
    @IBOutlet weak var nyTempLabel: UILabel!
    @IBOutlet weak var nyNameLabel: UILabel!
    @IBOutlet weak var nyConditionLabel: UILabel!
    @IBOutlet weak var nyDescriptionLabel: UILabel!
    @IBOutlet weak var nyTempMinLabel: UILabel!
    @IBOutlet weak var nyTempMaxLabel: UILabel!
        
    @IBOutlet weak var nyWeatherStackView: UIStackView!
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityNameTextField.delegate = self
        
        for viewToHide in weatherViewsToHide {
            viewToHide.isHidden = true
        }
        nyWeatherStackView.isHidden = true
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
                
        getNewYorkWeather()
    }
    
    //MARK: - IBAction
    @IBAction func searchPressed(_ sender: UIButton) {
        searchCityWeather()
    }
    
    //MARK: - Private methods
    // Get weather from search textField
    private func searchCityWeather() {
        getWeather()
        
        cityNameTextField.endEditing(true)
        cityNameTextField.text = nil
    }
    
    // Get weather and update views with the weather
    private func getWeather() {
        WeatherManager.shared.getWeather(for: cityNameTextField.text) { success, weather in
            if success {
                self.updateWeatherViews(with: weather!)
            } else {
                self.presentErrorMessage(with: "Failed to fetch weather")
            }
        }
    }
    
    // Get NY weather and update NY weather views
    private func getNewYorkWeather() {
        WeatherManager.shared.getWeather(for: "New+York") { success, NYWeather in
            if success {
                self.updateNYWeatherViews(with: NYWeather!)
            } else {
                self.presentErrorMessage(with: "Failed to fetch New York weather")
            }
        }
    }
    
    // Update weather views
    private func updateWeatherViews(with weather: WeatherModel) {
        if searchWeatherLabel.isHidden == false {
            firstUIUpdate()
        }
        
        self.weatherConditionImageView.image = UIImage(systemName: weather.conditionName)
        self.tempLabel.text = "\(weather.temperatureString)°C"
        self.cityNameLabel.text = weather.cityName
        self.conditionLabel.text = "🌞 \(weather.condition)"
        self.descriptionLabel.text = "ℹ️ \(weather.description)"
        self.tempMinLabel.text = "⬇ \(weather.tempMin)°C"
        self.tempMaxLabel.text = "⬆ \(weather.tempMax)°C"
        self.pressureLabel.text = "🔄 \(weather.pressure) hPa"
        self.humidityLabel.text = "💧 \(weather.humidity) %"
    }
    
    // Update NY weather views
    private func updateNYWeatherViews(with weather: WeatherModel) {
        nyWeatherStackView.isHidden = false
        
        self.nyWeatherConditionImageView.image = UIImage(systemName: weather.conditionName)
        self.nyTempLabel.text = "\(weather.temperatureString)°C"
        self.nyNameLabel.text = weather.cityName
        self.nyConditionLabel.text = "🌞 \(weather.condition)"
        self.nyDescriptionLabel.text = "ℹ️ \(weather.description)"
        self.nyTempMinLabel.text = "⬇ \(weather.tempMin)°C"
        self.nyTempMaxLabel.text = "⬆ \(weather.tempMax)°C"
    }
    
    // Present and Error Alert Controller
    private func presentErrorMessage(with error: String) {
        let ac = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(ac, animated: true)
    }
    
    // Perform first UI update
    private func firstUIUpdate() {
        for viewToHide in weatherViewsToHide {
            viewToHide.isHidden = false
        }
        searchWeatherLabel.isHidden = true
    }
}

//MARK: - Extension
// Hide keyboard when return pressed
extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchCityWeather()
        
        return true
    }
}
