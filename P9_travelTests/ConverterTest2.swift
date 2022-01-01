//
//  ConverterTest2.swift
//  P9_travelTests
//
//  Created by Sebastien Gaillard on 01/01/2022.
//

import XCTest
@testable import P9_travel

class ConverterTest2: XCTestCase {
    
    var converter: ConverterManager!
    
//    override func setUp() {
//        super.setUp()
//        TestURLProtocol.loadingHandler = { request in
//            let response: HTTPURLResponse = FakeResponseData.responseOK
//            let error: Error? = nil
//            let data: Data? = FakeResponseData.ratesData
//            return (response, data, error)
//        }
//        let configuration = URLSessionConfiguration.ephemeral
//        configuration.protocolClasses = [TestURLProtocol.self]
//        let session = URLSession(configuration: configuration)
//        converter = ConverterManager(session: session)
//    }
    
    
    func testGetRatesShouldPostFailesCallbackIfError() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let data: Data? = nil
            let response: HTTPURLResponse = FakeResponseData.responseKO
            let error: Error? = FakeResponseData.error
            return (response, data, error)
        }
//        let configuration = URLSessionConfiguration.ephemeral
//        configuration.protocolClasses = [TestURLProtocol.self]
//        let session = URLSession(configuration: configuration)
//        let converterManager = ConverterManager(session: session)
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
    
}



