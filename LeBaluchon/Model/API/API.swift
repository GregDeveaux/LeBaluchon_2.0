//
//  API.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 17/10/2022.
//

import Foundation

struct API {

    enum Method: String {
        case GET, POST, PUSH
    }

    static func translate(sentence: String,
                          sourceLang: String,
                          targetLang: String) -> String {
        
        var sentence = sentence
        let sourceLang = sourceLang
        let targetLang = targetLang

        API.QueryService.shared.getTranslate(endpoint: .translation(sourceLang: sourceLang,
                                                                    text: sentence,
                                                                    targetLang: targetLang),
                                             method: .POST) { success, recover in

            guard let recover = recover, success == true else {
                print(API.Error.generic(reason: "not shown data"))
                return
            }
            DispatchQueue.main.async {
                if let text = recover.translations.first?.text {
                    sentence = text
                }
            }
        }
        print("le texte traduit est ************* \(sentence)")
        return sentence
    }
}
