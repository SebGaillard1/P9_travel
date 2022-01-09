//
//  ChangeViewController.swift
//  P9_travel
//
//  Created by Sebastien Gaillard on 26/12/2021.
//

import UIKit

class ConverterViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var typeHereLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var currencyPickerView: UIPickerView!
    
    //MARK: - Private property
    private var currentRow = 0
        
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        currencyPickerView.delegate = self
        currencyPickerView.dataSource = self
                
        typeHereLabel.text = "Amount to convert:"
        
        amountTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(presentAlert(notification:)), name: Notification.Name("alert"), object: nil)
        
        refreshRates()
    }
    
    //MARK: - AlertController from notification
    @objc private func presentAlert(notification: Notification) {
        guard let alertMessage = notification.userInfo!["message"] as? String else { return }
        let alert = UIAlertController(title: "Error", message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
    
    //MARK: - Private methods
    // Display the fetched rates in pickerView and enable user input
    private func refreshRates() {
        ConverterManager.shared.getRates { success, _ in
            if success {
                self.currencyPickerView.reloadAllComponents()
                self.amountTextField.isUserInteractionEnabled = true
            }
        }
    }
    
    // Update result only if there is a currency to convert to
    private func updateResultTextField() {
        if !ConverterManager.shared.currencies.isEmpty {
            resultLabel.text = "\(ConverterManager.shared.convert(amount: amountTextField.text, from: ConverterManager.shared.currencies[currentRow])) USD"
        }
    }
    
    // Allow only number and only one decimal point into amount textField
    private func checkForForbiddenCharacters() {
        amountTextField.text = amountTextField.text?.onlyNumbers
        amountTextField.text = amountTextField.text?.replacingOccurrences(of: ",", with: ".")
        
        // Remove . if there is already one
        if let i = amountTextField.text?.firstIndex(of: ".") {
            var stringCopy = amountTextField.text
            stringCopy?.remove(at: i)
            
            if stringCopy?.contains(".") == true {
                amountTextField.text?.removeLast()
            }
        }
    }
    
    //MARK: - Selector
    // Check for invalid character at every key pressed and update result
    @objc private func textFieldDidChange(_ textField: UITextField) {
        checkForForbiddenCharacters()
        updateResultTextField()
    }
}

//MARK: - Picker View
extension ConverterViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ConverterManager.shared.currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ConverterManager.shared.currencies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentRow = row
        updateResultTextField()
    }
}
