//
//  TranslatorTests.swift
//  P9_travelTests
//
//  Created by Sebastien Gaillard on 01/01/2022.
//

import XCTest
@testable import P9_travel

class TranslatorTests: XCTestCase {

    var translator: TranslatorManager!
    
    func testMakeRequestShouldPostFailedCallBackIfNoData() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let data: Data? = nil
            let response: HTTPURLResponse = FakeResponseData.responseKO
            let error: Error? = nil
            return (response, data, error)
        }
        let translatorManager = createSession()

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translatorManager.makeRequest(usingTranslationAPI: .supportedLanguages, urlParams: ["":""]) { success, data in
            // Then
            XCTAssertFalse(success)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.1)
    }

    func testMakeRequestShouldPostFailedCallbackIfError() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let data: Data? = FakeResponseData.supportedLanguages
            let response: HTTPURLResponse = FakeResponseData.responseKO
            let error: Error? = FakeResponseData.error
            return (response, data, error)
        }
        let translatorManager = createSession()

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translatorManager.makeRequest(usingTranslationAPI: .supportedLanguages, urlParams: ["":""]) { success, data in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(data)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.1)
    }

    func testMakeRequestShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let data: Data? = FakeResponseData.supportedLanguages
            let response: HTTPURLResponse = FakeResponseData.responseKO
            let error: Error? = nil
            return (response, data, error)
        }
        let translatorManager = createSession()

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translatorManager.makeRequest(usingTranslationAPI: .supportedLanguages, urlParams: ["":""]) { success, data in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(data)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.1)
    }

    func testMakeRequestShouldPostFailedCallbackIfIncorrectData() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let data: Data? = FakeResponseData.incorrectData
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            return (response, data, error)
        }
        let translatorManager = createSession()

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translatorManager.makeRequest(usingTranslationAPI: .supportedLanguages, urlParams: ["":""]) { success, data in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(data)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.1)
    }

    func testMakeRequestShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let data: Data? = FakeResponseData.supportedLanguages
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            return (response, data, error)
        }
        let translatorManager = createSession()

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translatorManager.makeRequest(usingTranslationAPI: .supportedLanguages, urlParams: ["":""]) { success, data in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(data)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetLanguagesShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let data: Data? = FakeResponseData.supportedLanguages
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            return (response, data, error)
        }
        let translatorManager = createSession()

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translatorManager.getSupportedLanguages { success in
            XCTAssertTrue(success)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetLanguagesShouldPostFailedCallbackIfNoData() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let data: Data? = nil
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            return (response, data, error)
        }
        let translatorManager = createSession()

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translatorManager.getSupportedLanguages { success in
            XCTAssertFalse(success)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.1)
    }
    
    func testTranslateShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let data: Data? = FakeResponseData.translateData
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            return (response, data, error)
        }
        
        translator = createSession()
        translator.textToTranslate = "Bonjour"
        translator.targetLanguageCode = "en"
        translator.sourceLanguageCode = "fr"

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translator.translate { translation in
            XCTAssertNotNil(translation)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.1)
    }
    
    func testTranslateShouldPostFailedCallbackIfIncorrectData() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let data: Data? = FakeResponseData.incorrectData
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            return (response, data, error)
        }
        
        translator = createSession()
        translator.textToTranslate = "Bonjour"
        translator.targetLanguageCode = "en"

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translator.translate { translation in
            XCTAssertNil(translation)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.1)
    }
    
    func testDetectLanguageShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let data: Data? = FakeResponseData.detectedLanguage
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            return (response, data, error)
        }
        
        translator = createSession()
        translator.supportedLanguages.append(TranslationLanguage(code: "fr", name: "Français"))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translator.detectLanguage(forText: "Bonjour") { language in
            XCTAssertNotNil(language)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.1)
    }
    
    func testDetectLanguageShouldPostFailedCallbackIfNoCorrespondingSupportedLanguage() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let data: Data? = FakeResponseData.detectedLanguage
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            return (response, data, error)
        }
        
        translator = createSession()

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translator.detectLanguage(forText: "Bonjour") { language in
            XCTAssertNil(language)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.1)
    }
    
    func testDetectLanguageShouldPostFailedCallbackIfBadData() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let data: Data? = FakeResponseData.incorrectData
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            return (response, data, error)
        }
        
        translator = createSession()

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translator.detectLanguage(forText: "Bonjour") { language in
            XCTAssertNil(language)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.1)
    }
    
    func createSession() -> TranslatorManager {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestURLProtocol.self]
        let session = URLSession(configuration: configuration)
        return TranslatorManager(session: session)
    }
}
