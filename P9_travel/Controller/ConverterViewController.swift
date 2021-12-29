//
//  ChangeViewController.swift
//  P9_travel
//
//  Created by Sebastien Gaillard on 26/12/2021.
//

import UIKit

class ConverterViewController: UIViewController {
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var typeHereLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var currencyPickerView: UIPickerView!
    
    private var currentRow = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        currencyPickerView.delegate = self
        currencyPickerView.dataSource = self
        
        amountTextField.delegate = self // Unused
        
        typeHereLabel.text = "Amount to convert:"
        
        amountTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        refreshRates()
    }
    
    private func refreshRates() {
        ConverterManager.shared.getRates { success, _ in
            if !success {
                self.amountTextField.isUserInteractionEnabled = false
                
                let ac = UIAlertController(title: "Error", message: "Failed to fetch rates", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac, animated: true)
            } else {
                self.currencyPickerView.reloadAllComponents()
                self.amountTextField.isUserInteractionEnabled = true
            }
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        checkForForbiddenCharacters()
        updateResultTextField()
    }
    
    private func updateResultTextField() {
        if !ConverterManager.shared.currencies.isEmpty {
            resultLabel.text = "\(ConverterManager.shared.convert(amount: amountTextField.text, to: ConverterManager.shared.currencies[currentRow])) USD"
        }
    }
    
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
}

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

extension ConverterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
