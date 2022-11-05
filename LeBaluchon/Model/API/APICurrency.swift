//
//  APICurrency.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 16/10/2022.
//

import Foundation

extension API {

    enum Currency {

        struct CalculateExchangeRate: Decodable {
            let success: Bool
            let query: Query
            let info: Info
            let date: String
            let result: Double
        }

        struct Query: Decodable {
            let from: String
            let to: String
            let amount: Double
        }

        struct Info: Decodable {
            let timestamp: Int
            let rate: Double
        }

        struct IDCurrency: Decodable {
            let acronym: String
            let name: String
            let icon: String
        }
    }
}
