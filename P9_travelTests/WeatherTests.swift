//
//  WeatherTests.swift
//  P9_travelTests
//
//  Created by Sebastien Gaillard on 01/01/2022.
//

import XCTest
@testable import P9_travel

class WeatherTests: XCTestCase {
    func testGetWeatherShouldPostFailedCallBackIfNoData() {
        // Given
        let weatherManager = WeatherManager(session: URLSessionFake(data: nil, response: nil, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherManager.fetchWeather(cityName: "Paris", callBack: { success, data in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(data)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherShouldPostFailedCallbackIfError() {
        // Given
        let weatherManager = WeatherManager(session: URLSessionFake(data: FakeResponseData.weatherData, response: FakeResponseData.responseOK, error: FakeResponseData.error))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherManager.fetchWeather(cityName: "Paris", callBack: { success, data in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(data)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let weatherManager = WeatherManager(session: URLSessionFake(data: FakeResponseData.weatherData, response: FakeResponseData.responseKO, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherManager.fetchWeather(cityName: "Paris", callBack: { success, data in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(data)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRatesShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let weatherManager = WeatherManager(session: URLSessionFake(data: FakeResponseData.incorrectData, response: FakeResponseData.responseOK, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherManager.fetchWeather(cityName: "Paris", callBack: { success, data in
                // Then
                XCTAssertFalse(success)
                XCTAssertNil(data)
                expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }


    func testGetWeatherShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let weatherManager = WeatherManager(session: URLSessionFake(data: FakeResponseData.weatherData, response: FakeResponseData.responseOK, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherManager.fetchWeather(cityName: "Paris", callBack: { success, data in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(data)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }

}
