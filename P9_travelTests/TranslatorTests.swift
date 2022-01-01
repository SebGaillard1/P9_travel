//
//  TranslatorTests.swift
//  P9_travelTests
//
//  Created by Sebastien Gaillard on 01/01/2022.
//

import XCTest
@testable import P9_travel

class TranslatorTests: XCTestCase {
    
    func testGetSupportedLanguagesShouldPostFailedCallBackIfNoData() {
        // Given
        let translatorManager = TranslatorManager(session: URLSessionFake(data: nil, response: nil, error: nil))

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
        let translatorManager = TranslatorManager(session: URLSessionFake(data: FakeResponseData.supportedLanguages, response: FakeResponseData.responseOK, error: FakeResponseData.error))
        
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
        let translatorManager = TranslatorManager(session: URLSessionFake(data: FakeResponseData.supportedLanguages, response: FakeResponseData.responseKO, error: nil))

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
        let translatorManager = TranslatorManager(session: URLSessionFake(data: FakeResponseData.incorrectData, response: FakeResponseData.responseOK, error: nil))

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
        let translatorManager = TranslatorManager(session: URLSessionFake(data: FakeResponseData.supportedLanguages, response: FakeResponseData.responseOK, error: nil))

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
}
