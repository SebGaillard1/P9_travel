//
//  TestURLProtocol.swift
//  P9_travelTests
//
//  Created by Sebastien Gaillard on 01/01/2022.
//

import Foundation
import XCTest

final class TestURLProtocol: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    static var loadingHandler: ((URLRequest) -> (HTTPURLResponse, Data?, Error?))?

    override func startLoading() {
        guard let handler = TestURLProtocol.loadingHandler else {
            XCTFail("Loading handler is not set.")
            return
        }
        
        let (response, data, _) = handler(request)
        if let data = data {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        }
        else {
            class ProtocolError: Error {}
            let protocolError = ProtocolError()
            client?.urlProtocol(self, didFailWithError: protocolError)
        }
    }

    override func stopLoading() {
    }
    
}
