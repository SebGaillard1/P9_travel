//
//  LanguagesViewController.swift
//  P9_travel
//
//  Created by Sebastien Gaillard on 27/12/2021.
//

import UIKit

class LanguagesViewController: UIViewController {
    @IBOutlet weak var languagesTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    let cellId = "TableViewCell"
    
    var isTargetLanguage = false
    
    var delegate: LanguageViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        languagesTableView.dataSource = self
        languagesTableView.delegate = self
        languagesTableView.register(UINib.init(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
        
        if isTargetLanguage {
            titleLabel.text = "Choose target language"
        } else {
            titleLabel.text = "Choose source language"
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension LanguagesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TranslatorManager.shared.supportedLanguages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? LanguageCell else { return UITableViewCell() }
        
        let language = TranslatorManager.shared.supportedLanguages[indexPath.row]
        
        cell.languageLabel.text = language.name ?? ""
        cell.codeLabel.text = language.code ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isTargetLanguage {
            TranslatorManager.shared.targetLanguageCode = TranslatorManager.shared.supportedLanguages[indexPath.row].code
        } else {
            TranslatorManager.shared.sourceLanguageCode = TranslatorManager.shared.supportedLanguages[indexPath.row].code
        }
        
        delegate.sendLanguage(language: TranslatorManager.shared.supportedLanguages[indexPath.row].name!)
        delegate.enableTransButton()
        self.dismiss(animated: true)
    }
}

protocol LanguageViewControllerDelegate {
    func sendLanguage(language: String)
    
    func enableTransButton()
}
