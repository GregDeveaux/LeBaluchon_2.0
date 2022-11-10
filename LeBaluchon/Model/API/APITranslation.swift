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

//    static func translate(sentence: String, sourceLang: String, targetLang: String) async throws -> String {
//
//        var sentence = sentence
//        let sourceLang = sourceLang
//        let targetLang = targetLang
//
//        API.QueryService.shared.getTranslate(endpoint: .translation(sourceLang: sourceLang, text: sentence, targetLang: targetLang),
//                                             method: .GET) { success, recover in
//
//            guard let recover = recover, success == true else {
//                print(API.Error.generic(reason: "not shown data"))
//                return
//            }
//                if let recover = recover.translations.first?.text {
//                    sentence = recover
//                    print("le texte traduit est ************* \(sentence)")
//            }
//        }
//        return sentence
//    }

    static func translate(sentence: String, sourceLang: String, targetLang: String, sentenceTranslate: @escaping(String) -> Void) {

        let sentence = sentence
        let sourceLang = sourceLang
        let targetLang = targetLang

        API.QueryService.shared.getTranslate(endpoint: .translation(sourceLang: sourceLang, text: sentence, targetLang: targetLang),
                                             method: .GET) { success, recover in

            guard let recover = recover, success == true else {
                print(API.Error.generic(reason: "not shown data"))
                return
            }
                if let sentence = recover.translations.first?.text {
                    sentenceTranslate(sentence)
                    print("le texte traduit est ************* \(sentence)")
            }
        }
    }

}
