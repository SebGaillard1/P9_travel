//
//  TranslationManager.swift
//  P9_travel
//
//  Created by Sebastien Gaillard on 27/12/2021.
//

import Foundation

enum TranslationAPI {
    case detectLanguage
    case translate
    case supportedLanguages
    
    func getURL() -> String {
        var urlString = ""
        
        switch self {
        case .detectLanguage:
            urlString = "https://translation.googleapis.com/language/translate/v2/detect"
        case .translate:
            urlString = "https://translation.googleapis.com/language/translate/v2"
        case .supportedLanguages:
            urlString = "https://translation.googleapis.com/language/translate/v2/languages"
        }
        
        return urlString
    }
    
    func getHTTPMethod() -> String {
        if self == .supportedLanguages {
            return "GET"
        } else {
            return "POST"
        }
    }
}

struct TranslationLanguage {
    var code: String?
    var name: String?
}

class TranslatorManager {
    static let shared = TranslatorManager()
    private init() {}
        
    private let apiKey = "AIzaSyCqKWJpn9tjEuHV0mrx31nl25XUzlIugpg"

    var supportedLanguages = [TranslationLanguage]()
    var textToTranslate: String?
    var targetLanguageCode: String?
    var sourceLanguageCode: String?
    
    private var session = URLSession(configuration: .default)
    private var task: URLSessionDataTask?
    
    init(session: URLSession) {
        self.session = session
    }
    
    // We create the request with the url + params and then, perform the request
    func makeRequest(usingTranslationAPI api: TranslationAPI, urlParams: [String: String], callBack: @escaping (Bool, [String: Any]?) -> Void) {
        guard var components = URLComponents(string: api.getURL()) else { callBack(false, nil); return }
        
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in urlParams {
            components.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        
        // Now we have to create a URLRequest using the URL built from the components object and the appropriate HTTP method
        guard let url = components.url else { callBack(false, nil); return }
        
        var request = URLRequest(url: url)
        request.httpMethod = api.getHTTPMethod()
        
        // Now we create a URLSession and a data task
        task?.cancel()
        task = session.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                guard let data = data, error == nil else { callBack(false, nil); return }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { callBack(false, nil); return }
                
                guard let resultDict = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any] else { callBack(false, nil); return }
                
                callBack(true, resultDict)
            }
        }
        
        task?.resume()
    }
    
    func getSupportedLanguages(callBack: @escaping (Bool) -> Void) {
        var urlParams = [String: String]()
        urlParams["key"] = apiKey
        urlParams["target"] = Locale.current.languageCode ?? "en"
        
        makeRequest(usingTranslationAPI: .supportedLanguages, urlParams: urlParams) { _, data in
            guard let data = data else { callBack(false); return }
            
            let parseSuccess = self.parseJSONForSupportedLanguages(with: data)
            callBack(parseSuccess)
        }
    }
    
    private func parseJSONForSupportedLanguages(with data: [String: Any]) -> Bool {
        guard let data = data["data"] as? [String: Any], let languages = data["languages"] as? [[String:Any]] else { return false }
        
        for lang in languages {
            var languageCode: String?
            var languageName: String?
            
            if let code = lang["language"] as? String {
                languageCode = code
            }
            if let name = lang["name"] as? String {
                languageName = name
            }
            
            supportedLanguages.append(TranslationLanguage(code: languageCode, name: languageName))
        }
        return true
    }
    
    func translate(callBack: @escaping (String?) -> Void) {
        guard let textToTranslate = textToTranslate, let targetLanguage = targetLanguageCode else { callBack(nil); return }
        
        var urlParam = [String: String]()
        urlParam["key"] = apiKey
        urlParam["q"] = textToTranslate
        urlParam["target"] = targetLanguage
        urlParam["format"] = "text"
      
        if let sourceLanguage = sourceLanguageCode {
            urlParam["source"] = sourceLanguage
        }
        
        makeRequest(usingTranslationAPI: .translate, urlParams: urlParam) { success, data in
            guard let data = data else { callBack(nil); return }
            callBack(self.parseJSONTranslate(with: data))
        }
    }
    
    private func parseJSONTranslate(with data: [String: Any]) -> String? {
        guard let data = data["data"] as? [String: Any], let translations = data["translations"] as? [[String: Any]] else { return nil }
        var allTranslations = [String]()
        
        for translation in translations {
            if let translatedText = translation["translatedText"] as? String {
                allTranslations.append(translatedText)
            }
        }
        
        // We expect only 1 translation
        if allTranslations.count > 0 {
            return allTranslations[0]
        } else {
            return nil
        }
    }
    
    func detectLanguage(forText text: String, callBack: @escaping (String?) -> Void) {
        let urlParams = ["key": apiKey, "q": text]
        
        makeRequest(usingTranslationAPI: .detectLanguage, urlParams: urlParams) { success, data in
            guard let data = data else { callBack(nil); return }
            
            if let data = data["data"] as? [String: Any], let detections = data["detections"] as? [[[String: Any]]] {
                var detectedLanguages = [String]()
                
                for detection in detections {
                    for currentDetection in detection {
                        if let language = currentDetection["language"] as? String {
                            detectedLanguages.append(language)
                        }
                    }
                }
                
                if detectedLanguages.count > 0 {
                    self.sourceLanguageCode = detectedLanguages[0]
                    
                    let languageName = self.getLanguageName(fromCode: self.sourceLanguageCode)
                    callBack(languageName)
                } else {
                    callBack(nil)
                }
            }
        }
    }
    
    private func getLanguageName(fromCode code: String?) -> String? {
        if let code = code {
            for language in supportedLanguages {
                if language.code == code {
                    return language.name
                }
            }
        }
        
        return nil
    }
}
