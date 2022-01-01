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
    
    func testGetSupportedLanguagesShouldPostFailedCallBackIfNoData() {
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

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetSupportedLanguagesShouldPostFailedCallbackIfError() {
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

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetSupportedLanguagesShouldPostFailedCallbackIfIncorrectResponse() {
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

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetSupportedLanguagesShouldPostFailedCallbackIfIncorrectData() {
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

        wait(for: [expectation], timeout: 0.01)
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
        translatorManager.makeRequest(usingTranslationAPI: .supportedLanguages, urlParams: ["":""]) { success, data in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(data)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }
    
    func createSession() -> TranslatorManager {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestURLProtocol.self]
        let session = URLSession(configuration: configuration)
        return TranslatorManager(session: session)
    }
}
