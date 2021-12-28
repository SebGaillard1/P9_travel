//
//  TraductionViewController.swift
//  P9_travel
//
//  Created by Sebastien Gaillard on 26/12/2021.
//

import UIKit

class TranslationViewController: UIViewController, LanguageViewControllerDelegate {
    @IBOutlet weak var userInputTextView: UITextView!
    @IBOutlet weak var outputTextView: UITextView!
    @IBOutlet weak var tradButton: UIButton!
    @IBOutlet weak var sourceLanguageButton: UIButton!
    @IBOutlet weak var targetLanguageButton: UIButton!
    
    private var buttonTag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func sourceLanguageButton(_ sender: UIButton) {
        buttonTag = sender.tag
        performSegue(withIdentifier: "segueToSelectLanguage", sender: self)
    }
    
    @IBAction func destinationLanguageButton(_ sender: UIButton) {
        buttonTag = sender.tag
        performSegue(withIdentifier: "segueToSelectLanguage", sender: self)
    }
    
    @IBAction func tradButtonPressed(_ sender: Any) {
        TranslationManager.shared.textToTranslate = userInputTextView.text
        startTranslation()
    }
    
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
    
    private func startTranslation() {
        TranslationManager.shared.translate { translation in
            if translation != nil {
                // Success, we show the translation
                DispatchQueue.main.async {
                    self.outputTextView.text = translation
                }
            } else {
                // Failed, something went wrong
                print("wroooooong")
            }
        }
    }
    
    func sendLanguage(language: String) {
        if sourceLanguageButton.tag == buttonTag {
            sourceLanguageButton.setTitle(language, for: .normal)
        } else {
            targetLanguageButton.setTitle(language, for: .normal)
        }
    }
    
}
