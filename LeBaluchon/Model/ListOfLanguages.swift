//
//  ListOfLanguages.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 07/12/2022.
//

import Foundation

enum Language: String, CaseIterable {
    case french = "French"
    case english = "English"
    case italian = "Italian"
    case spanish = "Spanish"
    case portuguese = "Portuguese"
    case bulgarian = "Bulgarian"
    case chinese = "Chinese"
    case czech = "Czech"
    case danish = "Danish"
    case dutch = "Dutch"
    case german = "German"
    case greek = "Greek"
    case estonian = "Estonian"
    case finnish = "Finnish"
    case hungarian = "Hungarian"
    case indonesian = "Indonesian"
    case japanese = "Japanese"
    case lithuanian = "Lithuanian"
    case latvian = "Latvian"
    case polish = "Polish"
    case romanian = "Romanian"
    case russian = "Russian"
    case slovak = "Slovak"
    case slovenian = "Slovenian"
    case swedish = "Swedish"
    case turkish = "Turkish"
    case ukrainian = "Ukrainian"

    var code: String {
        switch self {
            case .french:
                return "FR"
            case .english:
                return "EN"
            case .italian:
                return "IT"
            case .spanish:
                return "ES"
            case .portuguese:
                return "PT"
            case .bulgarian:
                return "BG"
            case .chinese:
                return "ZH"
            case .czech:
                return "CS"
            case .danish:
                return "DA"
            case .dutch:
                return "NL"
            case .german:
                return "DE"
            case .greek:
                return "EL"
            case .estonian:
                return "ET"
            case .finnish:
                return "FI"
            case .hungarian:
                return "HU"
            case .indonesian:
                return "ID"
            case .japanese:
                return "JA"
            case .lithuanian:
                return "LT"
            case .latvian:
                return "LV"
            case .polish:
                return "PL"
            case .romanian:
                return "RO"
            case .russian:
                return "RU"
            case .slovak:
                return "SK"
            case .slovenian:
                return "SL"
            case .swedish:
                return "SV"
            case .turkish:
                return "TR"
            case .ukrainian:
                return "UK"
        }
    }
    
    var image: String {
        switch self {
            case .french:
                return "piece.png"
            case .english:
                return "sunWithFlagEnglish.png"
            case .italian:
                return "AppIcon.png"
            case .spanish:
                return "ES"
            case .portuguese:
                return "PT"
            case .bulgarian:
                return "BG"
            case .chinese:
                return "ZH"
            case .czech:
                return "CS"
            case .danish:
                return "DA"
            case .dutch:
                return "NL"
            case .german:
                return "DE"
            case .greek:
                return "EL"
            case .estonian:
                return "ET"
            case .finnish:
                return "FI"
            case .hungarian:
                return "HU"
            case .indonesian:
                return "ID"
            case .japanese:
                return "JA"
            case .lithuanian:
                return "LT"
            case .latvian:
                return "LV"
            case .polish:
                return "PL"
            case .romanian:
                return "RO"
            case .russian:
                return "RU"
            case .slovak:
                return "SK"
            case .slovenian:
                return "SL"
            case .swedish:
                return "SV"
            case .turkish:
                return "TR"
            case .ukrainian:
                return "UK"
        }
    }
}
