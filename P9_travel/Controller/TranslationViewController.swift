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
                
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        checkForLanguages()
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
        TranslatorManager.shared.textToTranslate = userInputTextView.text
        startTranslation()
    }
    
    @IBAction func detectLanguageButtonPressed(_ sender: UIButton) {
        if userInputTextView.text != "" {
            // Faire une waiting animation !!!!
            TranslatorManager.shared.detectLanguage(forText: userInputTextView.text) { language in
                if let language = language {
                    self.sourceLanguageButton.setTitle(language, for: .normal)
                } else {
                    let ac = UIAlertController(title: "Detect language", message: "Failed to detect language!", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated: true)
                }
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
        TranslatorManager.shared.translate { translation in
            if translation != nil {
                // Success, we show the translation
                DispatchQueue.main.async {
                    self.outputTextView.text = translation
                }
            } else {
                // Failed, something went wrong
                
            }
        }
    }
    
    // Enable selection of source or target language
    private func fetchSupportedLanguages() {
        TranslatorManager.shared.getSupportedLanguages { success in
            if success {
                self.sourceLanguageButton.isEnabled = true
                self.targetLanguageButton.isEnabled = true
            } else {
                // Inform : Failed to fetch languages
                let ac = UIAlertController(title: "Supported languages", message: "Something went wrong! Impossible to fetch supported languages", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.dismiss(animated: true)
                }))
                self.present(ac, animated: true)
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
    
    private func checkForLanguages() {
        if TranslatorManager.shared.supportedLanguages.isEmpty {
            fetchSupportedLanguages()
        }
    }
}
