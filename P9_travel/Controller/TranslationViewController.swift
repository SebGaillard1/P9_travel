//
//  TraductionViewController.swift
//  P9_travel
//
//  Created by Sebastien Gaillard on 26/12/2021.
//

import UIKit

class TranslationViewController: UIViewController, LanguageViewControllerDelegate {
    //MARK: - IBOutlets
    @IBOutlet weak var userInputTextView: UITextView!
    @IBOutlet weak var outputTextView: UITextView!
    @IBOutlet weak var tradButton: UIButton!
    @IBOutlet weak var sourceLanguageButton: UIButton!
    @IBOutlet weak var targetLanguageButton: UIButton!
    @IBOutlet weak var detectLanguageButton: UIButton!
    
    //MARK: - Private property
    private var buttonTag = 0
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(presentAlert(notification:)), name: Notification.Name("alert"), object: nil)
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        fetchSupportedLanguages()
    }
    
    //MARK: - AlertController from notification
    @objc private func presentAlert(notification: Notification) {
        guard let alertMessage = notification.userInfo!["message"] as? String else { return }
        let alert = UIAlertController(title: "Error", message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
    
    //MARK: - IBActions
    @IBAction func sourceLanguageButton(_ sender: UIButton) {
        buttonTag = sender.tag
        performSegue(withIdentifier: "segueToSelectLanguage", sender: self)
    }
    
    @IBAction func destinationLanguageButton(_ sender: UIButton) {
        buttonTag = sender.tag
        performSegue(withIdentifier: "segueToSelectLanguage", sender: self)
    }
    
    @IBAction func tradButtonPressed(_ sender: Any) {
        TranslatorService.shared.textToTranslate = userInputTextView.text
        startTranslation()
    }
    
    @IBAction func detectLanguageButtonPressed(_ sender: UIButton) {
        TranslatorService.shared.detectLanguage(forText: userInputTextView.text) { language in
            if let language = language {
                self.sourceLanguageButton.setTitle(language, for: .normal)
            }
        }
    }
    
    //MARK: - Segue preparation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToSelectLanguage" {
            let destinationVC = segue.destination as! LanguagesViewController
            destinationVC.delegate = self
            
            if buttonTag == 0 {
                destinationVC.isTargetLanguage = false
            } else {
                destinationVC.isTargetLanguage = true
            }
        }
    }
    
    //MARK: - Private methods
    // Display the result of the translation
    private func startTranslation() {
        TranslatorService.shared.translate { translation in
            if translation != nil {
                    self.outputTextView.text = translation
            }
        }
    }
    
    // Enable selection of source or target language
    private func fetchSupportedLanguages() {
        TranslatorService.shared.getSupportedLanguages { success in
            if success {
                self.sourceLanguageButton.isEnabled = true
                self.targetLanguageButton.isEnabled = true
            } 
        }
    }
    
    // Set button title to the language selected in the LanguagesViewController
    internal func sendLanguage(language: String) {
        if sourceLanguageButton.tag == buttonTag {
            sourceLanguageButton.setTitle(language, for: .normal)
        } else {
            targetLanguageButton.setTitle(language, for: .normal)
        }
    }
    
    // Enable translation button when a target language is selected in LanguagesViewController
    internal func enableTransButton() {
        tradButton.isEnabled = true
    }
}
