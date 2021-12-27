//
//  ChangeViewController.swift
//  P9_travel
//
//  Created by Sebastien Gaillard on 26/12/2021.
//

import UIKit

class ChangeViewController: UIViewController {
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var typeHereLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var currencyPickerView: UIPickerView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPickerView.delegate = self
        currencyPickerView.dataSource = self
        
        typeHereLabel.text = "Amount to convert:"
        convertButton.isEnabled = false
        
        refreshRates()
    }
    
    @IBAction func convertPressed(_ sender: UIButton) {
        refreshRates()
    }
    
    private func refreshRates() {
        ChangeService.shared.getRates { success, _ in
            if !success {
                let ac = UIAlertController(title: "Error", message: "Failed to fetch rates", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac, animated: true)
            } else {
                self.currencyPickerView.reloadAllComponents()
            }
        }
    }
}



extension ChangeViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ChangeService.shared.currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ChangeService.shared.currencies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        resultLabel.text = ChangeService.shared.convert(amount: amountTextField.text, to: ChangeService.shared.currencies[row])
    }
}

