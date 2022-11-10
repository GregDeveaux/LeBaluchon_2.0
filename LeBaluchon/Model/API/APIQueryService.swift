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
        var session = URLSession.shared
        private var task: URLSessionDataTask?

        func getCurrency(endpoint: EndPoint,
                         method: Method,
                         callback: @escaping (Bool, Currency.CalculateExchangeRate?) -> Void) {

            var request = URLRequest(url: endpoint.url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)

            request.allHTTPHeaderFields = endpoint.header

            request.httpMethod = method.rawValue

            print ("\(request)")
            print ("\(String(describing: request.allHTTPHeaderFields))")
            print ("\(String(describing: request.httpMethod))")

            task?.cancel()

            task = session.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    guard let data = data, error == nil else {
                        callback(false, nil)
                        print(Error.generic(reason: "There is not datas!"))
                        return
                    }

                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        callback(false, nil)
                        print(Error.generic(reason: "There is not a response!"))
                        return
                    }

                    print(String(data: data, encoding: .utf8)!)

                    let decoder = JSONDecoder()

                    do {
                        let decodeData = try decoder.decode(Currency.CalculateExchangeRate.self, from: data)
                        let calculateExchangeRate = decodeData
                        callback(true, calculateExchangeRate)
                        print(callback)
                    } catch {
                        callback(false, nil)
                        print(Error.generic(reason: "not parsing"))
                    }
                }
            }
            task?.resume()
        }

        func getWeather(endpoint: EndPoint,
                         method: Method,
                        callback: @escaping (Bool, Weather.DataForCity?) -> Void) {

            var request = URLRequest(url: endpoint.url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)

            request.httpMethod = method.rawValue

            print ("\(request)")
            print ("\(String(describing: request.allHTTPHeaderFields))")
            print ("\(String(describing: request.httpMethod))")

            task?.cancel()

            task = session.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    guard let data = data, error == nil else {
                        callback(false, nil)
                        print(Error.generic(reason: "There is not datas!"))
                        return
                    }

                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        callback(false, nil)
                        print(Error.generic(reason: "There is not a response!"))
                        return
                    }

                    print(String(data: data, encoding: .utf8)!)

                    let decoder = JSONDecoder()

                    do {
                        let decodeData = try decoder.decode(Weather.DataForCity.self, from: data)
                        let weatherForCity = decodeData
                        callback(true, weatherForCity)
                        print(callback)
                    } catch {
                        callback(false, nil)
                        print(Error.generic(reason: "not parsing"))
                    }
                }
            }
            task?.resume()
        }

        func getTranslate(endpoint: EndPoint,
                          method: Method,
                          callback: @escaping (Bool, Translation.Recover?) -> Void) {

            var request = URLRequest(url: endpoint.url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)

            request.httpMethod = method.rawValue

            print ("\(request)")
            print ("\(String(describing: request.allHTTPHeaderFields))")
            print ("\(String(describing: request.httpMethod))")

            task?.cancel()

            task = session.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    guard let data = data, error == nil else {
                        callback(false, nil)
                        print(Error.generic(reason: "There is not datas!"))
                        return
                    }

                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        callback(false, nil)
                        print(Error.generic(reason: "There is not a response!"))
                        return
                    }

                    print(String(data: data, encoding: .utf8)!)

                    let decoder = JSONDecoder()

                    do {
                        let decodeData = try decoder.decode(Translation.Recover.self, from: data)
                        let translate = decodeData
                        callback(true, translate)
                        print(callback)
                    } catch {
                        callback(false, nil)
                        print(Error.generic(reason: "not parsing"))
                    }
                }
            }
            task?.resume()
        }

        func getFlag(endpoint: EndPoint,
                          method: Method,
                     completionHandler: @escaping (Data?) -> Void) {

            var request = URLRequest(url: endpoint.url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)

//            request.allHTTPHeaderFields = endpoint.header

            request.httpMethod = method.rawValue

            print ("\(request)")
            print ("\(String(describing: request.allHTTPHeaderFields))")
            print ("\(String(describing: request.httpMethod))")

            task?.cancel()

            task = session.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else {
                        completionHandler(nil)
                        print(Error.generic(reason: "There is not datas!"))
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

        func getCoordinate(endpoint: EndPoint,
                           method: Method,
                           callback: @escaping (Bool, [City.Coordinates]?) -> Void) {
            var request = URLRequest(url: endpoint.url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)

            request.httpMethod = method.rawValue

            print ("\(request)")
            print ("\(String(describing: request.allHTTPHeaderFields))")
            print ("\(String(describing: request.httpMethod))")

            task?.cancel()

            task = session.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    guard let data = data, error == nil else {
                        callback(false, nil)
                        print(Error.generic(reason: "There is not datas!"))
                        return
                    }

                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        callback(false, nil)
                        print(Error.generic(reason: "There is not a response!"))
                        return
                    }

                    print(String(data: data, encoding: .utf8)!)

                    let decoder = JSONDecoder()

                    do {
                        let decodeData = try decoder.decode([City.Coordinates].self, from: data)
                        let coordinates = decodeData
                        callback(true, coordinates)
                        print(callback)
                    } catch {
                        callback(false, nil)
                        print(Error.generic(reason: "not parsing"))
                    }
                }
            }
            task?.resume()
        }


        func getAddress(endpoint: EndPoint, method: Method, callback: @escaping (Bool, City.Country?) -> Void) {
            var request = URLRequest(url: endpoint.url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)

            request.httpMethod = method.rawValue

            print ("\(request)")
            print ("\(String(describing: request.allHTTPHeaderFields))")
            print ("\(String(describing: request.httpMethod))")

            task?.cancel()

            task = session.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    guard let data = data, error == nil else {
                        callback(false, nil)
                        print(Error.generic(reason: "There is not datas!"))
                        return
                    }

                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        callback(false, nil)
                        print(Error.generic(reason: "There is not a response!"))
                        return
                    }

                    print(String(data: data, encoding: .utf8)!)

                    let decoder = JSONDecoder()

                    do {
                        let decodeData = try decoder.decode(City.Country.self, from: data)
                        let country = decodeData

                        let latitude = Double(country.latitude)!
                        let longitude = Double(country.longitude)!
                        let destinationCity = DestinationCity(country: country.address.country,
                                                              countryCode: country.address.countryCode,
                                                              coordinates: Coordinates(latitude: latitude, longitude: longitude))
                        callback(true, country)
                        print(callback)
                    } catch {
                        callback(false, nil)
                        print(Error.generic(reason: "not parsing"))
                    }
                }
            }
            task?.resume()
        }
    }
}
