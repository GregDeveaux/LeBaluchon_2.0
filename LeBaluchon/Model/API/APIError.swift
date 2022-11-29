//
//  APIError.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 17/10/2022.
//

import Foundation

extension API {

    enum Error: LocalizedError {
        case generic(reason: String)
        case `internal`(reason: String)

        var errorDescription: String? {
            switch self {
            case .generic(let reason):
                return "🛑 Interne error: \(reason)"
            case .internal(let reason):
                return "🛑 Interne error: \(reason)"
            }
        }
    }
}
