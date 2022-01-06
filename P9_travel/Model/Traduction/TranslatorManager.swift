//
//  TranslationManager.swift
//  P9_travel
//
//  Created by Sebastien Gaillard on 27/12/2021.
//

import Foundation

class TranslatorManager {
    //MARK: - Singleton Pattern
    static let shared = TranslatorManager()
    private init() {}
        
    //MARK: - Private properties
    private let apiKey = "AIzaSyCqKWJpn9tjEuHV0mrx31nl25XUzlIugpg"
    
    private var session = URLSession(configuration: .default)
    private var task: URLSessionDataTask?
    
    //MARK: - Public properties
    var supportedLanguages = [Languages]()
    var textToTranslate: String?
    var targetLanguageCode: String?
    var sourceLanguageCode: String?
   
    //MARK: - Initializer
    init(session: URLSession) {
        self.session = session
    }
    
    //MARK: - Alert Notification
    private func alertNotification(message: String) {
        let alertName = Notification.Name("alert")
        NotificationCenter.default.post(name: alertName, object: nil, userInfo: ["message": message])
    }
    
    private func createRequest(usingTranslationAPI api: TranslationAPI, urlParams: [String: String]) -> URLRequest? {
        guard var components = URLComponents(string: api.getURL()) else { return nil }
        
        components.queryItems = [URLQueryItem]()
        for (key, value) in urlParams {
            components.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        
        guard let url = components.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = api.getHTTPMethod()
        
        return request
    }
    
    //MARK: - Fetch the supported languages
    func getSupportedLanguages(callBack: @escaping (_ success: Bool) -> Void) {
        var urlParams = [String: String]()
        urlParams["key"] = apiKey
        urlParams["target"] = Locale.current.languageCode ?? "en"
        
        guard let request = createRequest(usingTranslationAPI: .supportedLanguages, urlParams: urlParams) else { callBack(false); return }
        
        task?.cancel()
        task = session.dataTask(with: request, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    self.alertNotification(message: "Cannot fetch supported languages")
                    callBack(false)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    self.alertNotification(message: "Bad response from server, cannot fetch supported languages")
                    callBack(false)
                    return
                }
                
                guard let responseJSON = try? JSONDecoder().decode(SupportedLanguagesData.self, from: data) else {
                    self.alertNotification(message: "Failed to fetch supported languages")
                    callBack(false)
                    return
                }
                
                for language in responseJSON.data.languages {
                    self.supportedLanguages.append(language)
                }
                callBack(true)
            }
        })
        
        task?.resume()
    }
    
    func translate(callBack: @escaping (_ translation: String?) -> Void) {
        guard let textToTranslate = textToTranslate, let targetLanguage = targetLanguageCode else { callBack(nil); return }

        if textToTranslate.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            alertNotification(message: "No text to translate")
            return
        }
        
        var urlParam = [String: String]()
        urlParam["key"] = apiKey
        urlParam["q"] = textToTranslate
        urlParam["target"] = targetLanguage
        urlParam["format"] = "text"
      
        if let sourceLanguage = sourceLanguageCode {
            urlParam["source"] = sourceLanguage
        }
        
        guard let request = createRequest(usingTranslationAPI: .translate, urlParams: urlParam) else { callBack(nil); return }
    
        task?.cancel()
        task = session.dataTask(with: request, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    self.alertNotification(message: "Cannot translate")
                    callBack(nil)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    self.alertNotification(message: "Bad response from server, failed to translate")
                    callBack(nil)
                    return
                }
                
                guard let responseJSON = try? JSONDecoder().decode(TranslationData.self, from: data) else {
                    self.alertNotification(message: "Failed to translate")
                    callBack(nil)
                    return
                }
                let translation = responseJSON.data.translations[0].translatedText
                
                callBack(translation)
            }
        })
        
        task?.resume()
    }
    
    func detectLanguage(forText text: String, callBack: @escaping (_ language: String?) -> Void) {
        let urlParams = ["key": apiKey, "q": text]
        
        guard let request = createRequest(usingTranslationAPI: .detectLanguage, urlParams: urlParams) else {callBack(nil); return }
        
        task?.cancel()
        
        task = session.dataTask(with: request, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    self.alertNotification(message: "Cannot detect language")
                    callBack(nil)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    self.alertNotification(message: "Bad response from server, cannot detect language")
                    callBack(nil)
                    return
                }
                
                guard let responseJSON = try? JSONDecoder().decode(DetectedLanguageData.self, from: data) else {
                    self.alertNotification(message: "Failed to detect language")
                    callBack(nil)
                    return
                }
                let languageCodeDetected = responseJSON.data.detections[0][0].language
                
                if languageCodeDetected == "und" {
                    self.alertNotification(message: "No language detected")
                    callBack(nil)
                    return
                }
                
                let languageName = self.getLanguageName(fromCode: languageCodeDetected)
                
                callBack(languageName)
            }
        })
        
        task?.resume()
    }
    
    //MARK: - Return languageName from languageCode
    private func getLanguageName(fromCode code: String?) -> String? {
        if let code = code {
            for language in supportedLanguages {
                if language.language == code {
                    return language.name
                }
            }
        }
        
        return nil
    }
}
