//
//  WeatherTests.swift
//  P9_travelTests
//
//  Created by Sebastien Gaillard on 01/01/2022.
//

import XCTest
@testable import P9_travel

class WeatherTests: XCTestCase {
    
    var weather: WeatherManager!
    
    func testGetWeatherShouldPostFailedCallBackIfNoData() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let data: Data? = nil
            let response: HTTPURLResponse = FakeResponseData.responseKO
            let error: Error? = nil
            return (response, data, error)
        }
        let weatherManager = createSession()

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherManager.getWeather(for: "", callBack: { success, data in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(data)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.1)
    }

    func testGetWeatherShouldPostFailedCallbackIfError() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let data: Data? = nil
            let response: HTTPURLResponse = FakeResponseData.responseKO
            let error: Error? = FakeResponseData.error
            return (response, data, error)
        }
        let weatherManager = createSession()
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherManager.getWeather(for: "", callBack: { success, data in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(data)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.1)
    }

    func testGetWeatherShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let data: Data? = FakeResponseData.weatherData
            let response: HTTPURLResponse = FakeResponseData.responseKO
            let error: Error? = nil
            return (response, data, error)
        }
        let weatherManager = createSession()

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherManager.getWeather(for: "", callBack: { success, data in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(data)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetRatesShouldPostFailedCallbackIfIncorrectData() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let data: Data? = FakeResponseData.incorrectData
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            return (response, data, error)
        }
        let weatherManager = createSession()

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherManager.getWeather(for: "", callBack: { success, data in
                // Then
                XCTAssertFalse(success)
                XCTAssertNil(data)
                expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.1)
    }


    func testGetWeatherShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let data: Data? = FakeResponseData.weatherData
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            return (response, data, error)
        }
        let weatherManager = createSession()

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherManager.getWeather(for: "", callBack: { success, data in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(data)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.1)
    }
  
    func createSession() -> WeatherManager {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestURLProtocol.self]
        let session = URLSession(configuration: configuration)
        return WeatherManager(session: session)
    }

}
