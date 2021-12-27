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

class TranslationManager {
    static let shared = TranslationManager()
    
    private static let urlTranslate = URL(string: "https://translation.googleapis.com/language/translate/v2")!
    
    private let apiKey = "AIzaSyCqKWJpn9tjEuHV0mrx31nl25XUzlIugpg"
    
    private init() {}
    
    private func makeRequest(usingTranslationAPI api: TranslationAPI, urlParams: [String: String], callback: @escaping (Bool, [String: Any]?) -> Void) {
        //        if var components = URLComponents(string: api.getURL()) {
        //            components.queryItems = [URLQueryItem]()
        //
        //            for (key, value) in urlParams {
        //                components.queryItems?.append(URLQueryItem(name: key, value: value))
        //            }
        //        } else {
        //            callback(false, nil)
        //        }
        
        // We have to add the URL parameters to our dictionnary. We use URLComponents for that
        guard var components = URLComponents(string: api.getURL()) else {
            callback(false, nil)
            return
        }
        
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in urlParams {
            components.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        
        // Now we have to create a URLRequest using the URL built from the components object and the appropriate HTTP method
        guard let url = components.url else {
            callback(false, nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = api.getHTTPMethod()
        
        // Now we create a URLSession and a data task
        // A extraire de la méthode !!!!!!!
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            // TO DO
        }
        
        task.resume()
    }
}


