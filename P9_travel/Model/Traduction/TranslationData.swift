//
//  TranslatorData.swift
//  P9_travel
//
//  Created by Sebastien Gaillard on 06/01/2022.
//

import Foundation

//MARK: - Translation data struct
struct TranslationData: Codable {
    let data: Translations
}

struct Translations: Codable {
    let translations: [TranslationDetails]
}

struct TranslationDetails: Codable {
    let translatedText: String
}

//MARK: - Supported languages data struct
struct SupportedLanguagesData: Codable {
    let data: LanguageData
}

struct LanguageData: Codable {
    let languages: [Languages]
}

struct Languages: Codable {
    let language: String
    let name: String
}

//MARK: - Detected language data struct
struct DetectedLanguageData: Codable {
    let data: DetectionsData
}

struct DetectionsData: Codable {
    let detections: [[Detections]]
}

struct Detections: Codable {
    let language: String
}
