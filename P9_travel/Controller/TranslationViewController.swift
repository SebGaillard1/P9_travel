//
//  TraductionViewController.swift
//  P9_travel
//
//  Created by Sebastien Gaillard on 26/12/2021.
//

import UIKit

class TranslationViewController: UIViewController {
    @IBOutlet weak var userInputTextView: UITextView!
    @IBOutlet weak var outputTextView: UITextView!
    @IBOutlet weak var tradButton: UIButton!
    @IBOutlet weak var sourceLanguageButton: UIButton!
    @IBOutlet weak var destinationLanguageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tradButtonPressed(_ sender: Any) {
        TranslationManager.shared.textToTranslate = userInputTextView.text
        startTranslation()
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
    

}
