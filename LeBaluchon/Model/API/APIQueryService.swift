//
//  APIClient.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 17/10/2022.
//
// ********************** MEMENTO *************************
// * Create the url of the request with URLRequest with : *
// * • url      • Header     • Method     • Body          *
// *                                                      *
// * Create a session for read the datas                  *
// * • URLSession     • DataTask (-error -response)       *
// *                                                      *
// * Resume                                               *
// ********************************************************

import Foundation

extension API {
    
    class QueryService {
        
        static let shared = QueryService()
        
        let urlSession: URLSession
        init(urlSession: URLSession = URLSession.shared) {
            self.urlSession = urlSession
        }
        
        private var task: URLSessionDataTask?
        
        func getData<Response: Decodable>(endpoint: EndPoint,
                                          method: Method = .GET,
                                          type: Response.Type,
                                          callback: @escaping (Result<Response, API.Error>) -> Void) {
            
            var request = URLRequest(url: endpoint.url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)

            // if use currency, add header
            if #available(iOS 16.0, *) {
                if request.url?.host() == "api.apilayer.com" {
                    request.allHTTPHeaderFields = endpoint.header
                }
            } else {
                if request.url?.host == "api.apilayer.com" {
                    request.allHTTPHeaderFields = endpoint.header
                }
            }
            
            request.httpMethod = method.rawValue
            print ("✅ \(request)")
            
            task?.cancel()
            
            task = urlSession.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    guard let data = data, error == nil else {
                        callback(.failure(.generic(reason: "there is not datas!")))
                        return
                    }
                    
                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        callback(.failure(.generic(reason: "there is not a response!")))
                        return
                    }
                    
                    print(String(data: data, encoding: .utf8)!)
                    
                    let decoder = JSONDecoder()
                    
                    do {
                        let decodeData = try decoder.decode(Response.self, from: data)
                        callback(.success(decodeData))
                    } catch {
                        print("🛑 Decoding error: \(error)")
                        callback(.failure(.internal(reason: "not decode data!")))
                    }
                }
            }
            
            task?.resume()
        }
        
        func getFlag(endpoint: EndPoint,
                     method: Method,
                     completionHandler: @escaping (Data?) -> Void) {
            
            var request = URLRequest(url: endpoint.url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
            
            request.httpMethod = method.rawValue
            print ("✅ \(request)")
            
            task?.cancel()
            
            task = urlSession.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    completionHandler(nil)
                    print(Error.generic(reason: "There is not flag!"))
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completionHandler(nil)
                    print(Error.generic(reason: "There is not a response!"))
                    return
                }
                
                completionHandler(data)
                
            }
            task?.resume()
        }
    }
}
