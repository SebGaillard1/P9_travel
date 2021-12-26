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
    
    var rates: Rates?
    
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
        ChangeService.shared.getRates { success, changeRates in
            if !success {
                let ac = UIAlertController(title: "Error", message: "Failed to fetch rates", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac, animated: true)
            } else {
                self.rates = changeRates
            }
        }
    }
}



extension ChangeViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Currencies.currenciesArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Currencies.currenciesArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("\(row) selected")
    }
}

