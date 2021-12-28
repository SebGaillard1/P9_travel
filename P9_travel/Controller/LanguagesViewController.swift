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
    
    var isTargetLanguage = false
    
    var delegate: LanguageViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        languagesTableView.dataSource = self
        languagesTableView.delegate = self
        languagesTableView.register(UINib.init(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
        
        checkForLanguages()
    }
    
    private func checkForLanguages() {
        if TranslationManager.shared.supportedLanguages.isEmpty {
            fetchSupportedLanguages()
        }
    }
    
    private func fetchSupportedLanguages() {
        TranslationManager.shared.fetchSupportedLanguages { success in
            if success {
                // Display language in table view
                DispatchQueue.main.async {
                    self.languagesTableView.reloadData()
                }
            } else {
                // Inform : Failed to fetch languages
                let ac = UIAlertController(title: "Supported languages", message: "Something went wrong! Impossible to fetch supported languages", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.dismiss(animated: true)
                }))
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isTargetLanguage {
            TranslationManager.shared.targetLanguageCode = TranslationManager.shared.supportedLanguages[indexPath.row].code
        } else {
            TranslationManager.shared.sourceLanguageCode = TranslationManager.shared.supportedLanguages[indexPath.row].code
        }
        
        delegate.sendLanguage(language: TranslationManager.shared.supportedLanguages[indexPath.row].name!)
        self.dismiss(animated: true)
    }
}

protocol LanguageViewControllerDelegate {
    func sendLanguage(language: String)

}