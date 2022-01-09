//
//  FakeResponseData.swift
//  P9_travelTests
//
//  Created by Sebastien Gaillard on 01/01/2022.
//

import Foundation

class FakeResponseData {
    //MARK: - Data
    static var ratesData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Rates", withExtension: ".json")!
        return try! Data(contentsOf: url)
    }
    
    static var badRatesData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "BadRates", withExtension: ".json")!
        return try! Data(contentsOf: url)
    }
    
    static var weatherData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Weather", withExtension: ".json")!
        return try! Data(contentsOf: url)
    }
    
    static var supportedLanguages: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "SupportedLanguages", withExtension: ".json")!
        return try! Data(contentsOf: url)
    }
    
    static var translateData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Translation", withExtension: ".json")!
        return try! Data(contentsOf: url)
    }
    
    static var detectedLanguage: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "DetectedLanguage", withExtension: ".json")!
        return try! Data(contentsOf: url)
    }
    
    static var failedDetectedLanguage: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "UndefinedDetectedLanguage", withExtension: ".json")!
        return try! Data(contentsOf: url)
    }
    
    static let incorrectData = "erreur".data(using: .utf8)
    
    //MARK: - Response
    static let responseOK = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 200, httpVersion: nil, headerFields: [:])!
    
    static let responseKO = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 500, httpVersion: nil, headerFields: [:])!
    
    //MARK: - Error
    class FakeError: Error {}
    static let error = FakeError()
}

