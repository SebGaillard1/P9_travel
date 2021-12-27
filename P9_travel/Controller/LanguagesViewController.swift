//
//  LanguagesViewController.swift
//  P9_travel
//
//  Created by Sebastien Gaillard on 27/12/2021.
//

import UIKit

class LanguagesViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var languagesTableView: UITableView!
    
    let cellId = "TableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        languagesTableView.dataSource = self
        languagesTableView.delegate = self
        languagesTableView.register(UINib.init(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
        
        checkForLanguages()
    }
    
    private func checkForLanguages() {
        if TranslationManager.shared.supportedLanguages.isEmpty {
//            let ac = UIAlertController(title: "No languages", message: "There is no supported languages to translate to. Would you like to try to fetch languages now ?", preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "Fetch supported languages now", style: .default, handler: fetchSupportedLanguages(action:)))
//            ac.addAction(UIAlertAction(title: "Not now", style: .cancel, handler: { _ in
//                self.dismiss(animated: true)
//            }))
            fetchSupportedLanguages()
        }
    }
    
//    private func fetchSupportedLanguages(action: UIAlertAction) {
//        // Show activity indicator
//        activityIndicator.isHidden = false
//
//        // Try to fetch supported languages
//        TranslationManager.shared.fetchSupportedLanguages { success in
//            if success {
//                // Display language in table view
//                DispatchQueue.main.async {
//                    self.languagesTableView.reloadData()
//                }
//            } else {
//                // Inform : Failed to fetch languages
//                let ac = UIAlertController(title: "Supported languages", message: "Something went wrong! Impossible to fetch supported languages", preferredStyle: .alert)
//                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
//                    self.dismiss(animated: true)
//                }))
//            }
//        }
//    }
    
    private func fetchSupportedLanguages() {
        TranslationManager.shared.fetchSupportedLanguages { success in
            if success {
                print("success")
                DispatchQueue.main.async {
                    self.languagesTableView.reloadData()
                }
            } else {
                print("failed")
            }
        }
    }
}

extension LanguagesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TranslationManager.shared.supportedLanguages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? LanguageCell else { return UITableViewCell() }
                
        let language = TranslationManager.shared.supportedLanguages[indexPath.row]
        
        cell.languageLabel.text = language.name ?? ""
        cell.codeLabel.text = language.code ?? ""
        
        return cell
    }
    
    
}
