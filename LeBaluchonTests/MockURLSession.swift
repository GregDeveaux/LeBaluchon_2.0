//
//  MockURLSession.swift
//  LeBaluchonTests
//
//  Created by Greg-Mini on 16/10/2022.
//

import UIKit

class MockURLSession: URLSession {

    var data: Data?
    var urlResponse: URLResponse?
    var error: Error?

    init(data:Data?, urlResponse: URLResponse?, error: Error?) {
        self.data = data
        self.urlResponse = urlResponse
        self.error = error
    }

    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = MockURLSessionDataTask()
        task.completionHandler = completionHandler
        return task
    }

    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = MockURLSessionDataTask()
        task.completionHandler = completionHandler
        return task
    }

}


class MockURLSessionDataTask: URLSessionDataTask {
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?

    var data: Data?
    var urlResponse: URLResponse?
    var responseError: Error?
    

    override func resume() {
        completionHandler?(data, urlResponse, responseError)
    }

    override func cancel() { }
}
