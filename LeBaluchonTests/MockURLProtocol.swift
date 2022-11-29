//
//  MockUrlProtocol.swift
//  LeBaluchonTests
//
//  Created by Greg Deveaux on 16/10/2022.
//

import XCTest

class MockURLProtocol: URLProtocol {

        // Handler to test the request and return mock response
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?

        // Allows to handle the different types of request
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

        // Allows return the canonical version of the request but we keep the orignal
        // Here to ignore this methodn
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

        // Allows to simulate response as per the test case and send it to the URLProtocolClient
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("Handler is unavailable.")
        }

        do {
                // Call handler with received request and capture the tuple of response and data.
            let (response, data) = try handler(request)
                // Send received response to the client.
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)

            if let data = data {
                    // Send received data to the client.
                client?.urlProtocol(self, didLoad: data)
            }

                // Notify request has been finished.
            client?.urlProtocolDidFinishLoading(self)

        } catch {
                // Notify received error.
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

        // this method is required but doesn't need to do anything
    override func stopLoading() { }
}
