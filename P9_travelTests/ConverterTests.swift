//
//  ConverterTest2.swift
//  P9_travelTests
//
//  Created by Sebastien Gaillard on 01/01/2022.
//

import XCTest
@testable import P9_travel

class ConverterTests: XCTestCase {
    
    var converter: ConverterManager!
    
    func testGetRatesShouldPostFailesCallbackIfError() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let data: Data? = nil
            let response: HTTPURLResponse = FakeResponseData.responseKO
            let error: Error? = FakeResponseData.error
            return (response, data, error)
        }

        let converterManager = createSession()
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        converterManager.getRates(callBack: { success, data in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(data)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetRatesShouldPostFailedCallBackIfNoData() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let data: Data? = nil
            let response: HTTPURLResponse = FakeResponseData.responseKO
            let error: Error? = nil
            return (response, data, error)
        }
        
        let converterManager = createSession()

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        converterManager.getRates { success, data in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(data)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetRatesShouldPostFailedCallbackIfIncorrectResponseAndError() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let data: Data? = FakeResponseData.ratesData
            let response: HTTPURLResponse = FakeResponseData.responseKO
            let error: Error? = nil
            return (response, data, error)
        }
        
        let converterManager = createSession()

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        converterManager.getRates { success, data in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(data)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRatesShouldPostFailedCallbackIfIncorrectData() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let data: Data? = FakeResponseData.incorrectData
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            return (response, data, error)
        }
        
        let converterManager = createSession()

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        converterManager.getRates { success, data in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(data)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetRatesShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let data: Data? = FakeResponseData.ratesData
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            return (response, data, error)
        }
        
        let converterManager = createSession()

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        converterManager.getRates { success, data in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(data)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func createSession() -> ConverterManager {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestURLProtocol.self]
        let session = URLSession(configuration: configuration)
        return ConverterManager(session: session)
    }
    
    func testGiven10AEDWhenConvertingToUSDThenShouldBe2Dot72() {
        converter = ConverterManager.shared
        converter.currenciesWithRates["AED"] = 4.176782
        converter.currenciesWithRates["USD"] = 1.137145
        
        let result = converter.convert(amount: "10", from: "AED")
        XCTAssertEqual(result, "2.72")
    }
    
    func testGiven10AEDWhenConvertingToUSDThenShouldNotBe2Dot73(){
        converter = ConverterManager.shared
        converter.currenciesWithRates["AED"] = 4.176782
        converter.currenciesWithRates["USD"] = 1.137145
        
        let result = converter.convert(amount: "10", from: "AED")
        XCTAssertNotEqual(result, "2.73")
    }
}



