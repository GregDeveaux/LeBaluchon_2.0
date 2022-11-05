//
//  APITranslation.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 23/10/2022.
//

import Foundation

extension API {

    enum Translation {
        struct Recover: Decodable {
            let translations: [Translated]
        }

        struct Translated: Decodable {
            var text: String
        }
    }

}
