//
//  ListOfLanguages.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 07/12/2022.
//

import Foundation

enum Language: String, CaseIterable {
    case French
    case English
    case Italian
    case Spanish
    case Portuguese
    case Bulgarian
    case Chinese
    case Czech
    case Danish
    case Dutch
    case German
    case Greek
    case Estonian
    case Finnish
    case Hungarian
    case Indonesian
    case Japanese
    case Lithuanian
    case Latvian
    case Polish
    case Romanian
    case Russian
    case Slovak
    case Slovenian
    case Swedish
    case Turkish
    case Ukrainian

    var code: String {
        switch self {
            case .French:
                return "FR"
            case .English:
                return "EN"
            case .Italian:
                return "IT"
            case .Spanish:
                return "ES"
            case .Portuguese:
                return "PT"
            case .Bulgarian:
                return "BG"
            case .Chinese:
                return "ZH"
            case .Czech:
                return "CS"
            case .Danish:
                return "DA"
            case .Dutch:
                return "NL"
            case .German:
                return "DE"
            case .Greek:
                return "EL"
            case .Estonian:
                return "ET"
            case .Finnish:
                return "FI"
            case .Hungarian:
                return "HU"
            case .Indonesian:
                return "ID"
            case .Japanese:
                return "JA"
            case .Lithuanian:
                return "LT"
            case .Latvian:
                return "LV"
            case .Polish:
                return "PL"
            case .Romanian:
                return "RO"
            case .Russian:
                return "RU"
            case .Slovak:
                return "SK"
            case .Slovenian:
                return "SL"
            case .Swedish:
                return "SV"
            case .Turkish:
                return "TR"
            case .Ukrainian:
                return "UK"
        }
    }
}
