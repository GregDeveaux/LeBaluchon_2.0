//
//  TranslateViewController+Language.swift
//  LeBaluchon
//
//  Created by Greg-Mini on 19/11/2022.
//

import UIKit

extension TranslateViewController {

    func setupActionsMenu(of languageButton: UIButton, currentTitleOtherButton: String) {

            // Create different pieces of menu
        let french = UIAction(title: "French") { _ in
            self.recognizeButtonLanguage(languageButton, codeLanguage: "FR")
        }

        let english = UIAction(title: "English") { _ in
            self.recognizeButtonLanguage(languageButton, codeLanguage: "EN")
        }

        let italian = UIAction(title: "Italian") { _ in
            self.recognizeButtonLanguage(languageButton, codeLanguage: "IT")
        }

        let spanish = UIAction(title: "Spanish") { _ in
            self.recognizeButtonLanguage(languageButton, codeLanguage: "ES")
        }

        let portuguese = UIAction(title: "Portuguese") { _ in
            self.recognizeButtonLanguage(languageButton, codeLanguage: "PT")
        }

        let bulgarian = UIAction(title: "Bulgarian") { _ in
            self.recognizeButtonLanguage(languageButton, codeLanguage: "BG")
        }

        let chinese = UIAction(title: "Chinese") { _ in
            self.recognizeButtonLanguage(languageButton, codeLanguage: "ZH")
        }

        let czech = UIAction(title: "Czech") { _ in
            self.recognizeButtonLanguage(languageButton, codeLanguage: "CS")
        }

        let danish = UIAction(title: "Danish") { _ in
            self.recognizeButtonLanguage(languageButton, codeLanguage: "DA")
        }

        let dutch = UIAction(title: "Dutch") { _ in
            self.recognizeButtonLanguage(languageButton, codeLanguage: "NL")
        }

        let german = UIAction(title: "German") { _ in
            self.recognizeButtonLanguage(languageButton, codeLanguage: "DE")
        }

        let greek = UIAction(title: "Greek") { _ in
            self.recognizeButtonLanguage(languageButton, codeLanguage: "EL")
        }

        let estonian = UIAction(title: "Estonian") { _ in
            self.recognizeButtonLanguage(languageButton, codeLanguage: "ET")
        }

        let finnish = UIAction(title: "Finnish") { _ in
            self.recognizeButtonLanguage(languageButton, codeLanguage: "FI")
        }

        let hungarian = UIAction(title: "Hungarian") { _ in
            self.recognizeButtonLanguage(languageButton, codeLanguage: "HU")
        }

        let indonesian = UIAction(title: "Indonesian") { _ in
            self.recognizeButtonLanguage(languageButton, codeLanguage: "ID")
        }

        let japanese = UIAction(title: "Japanese") { _ in
            self.recognizeButtonLanguage(languageButton, codeLanguage: "JA")
        }

        let lithuanian = UIAction(title: "Lithuanian") { _ in
            self.recognizeButtonLanguage(languageButton, codeLanguage: "LT")
        }

        let latvian = UIAction(title: "Latvian") { _ in
            self.recognizeButtonLanguage(languageButton, codeLanguage: "LV")
        }

        let polish = UIAction(title: "Polish") { _ in
            self.recognizeButtonLanguage(languageButton, codeLanguage: "PL")
        }

        let romanian = UIAction(title: "Romanian") { _ in
            self.recognizeButtonLanguage(languageButton, codeLanguage: "RO")
        }

        let russian = UIAction(title: "Russian") { _ in
            self.recognizeButtonLanguage(languageButton, codeLanguage: "RU")
        }

        let slovak = UIAction(title: "Slovak") { _ in
            self.recognizeButtonLanguage(languageButton, codeLanguage: "SK")
        }

        let slovenian = UIAction(title: "Slovenian") { _ in
            self.recognizeButtonLanguage(languageButton, codeLanguage: "SL")
        }

        let swedish = UIAction(title: "Swedish") { _ in
            self.recognizeButtonLanguage(languageButton, codeLanguage: "SV")
        }

        let turkish = UIAction(title: "Turkish") { _ in
            self.recognizeButtonLanguage(languageButton, codeLanguage: "TR")
        }

        let ukrainian = UIAction(title: "Ukrainian") { _ in
            self.recognizeButtonLanguage(languageButton, codeLanguage: "UK")
        }

        let actions: [UIAction] = [french, english, italian, spanish, portuguese, bulgarian, chinese, czech, danish, dutch,
                                  german, greek, estonian, finnish, hungarian, indonesian, japanese, lithuanian, latvian,
                                  polish, romanian, russian, slovak, slovenian, swedish, turkish, ukrainian]

        let actionsWithdeleteLanguageChooseInOtherButton = actions.filter({$0.title != currentTitleOtherButton})

        let menu = UIMenu(identifier: .text, options: .singleSelection, children: actionsWithdeleteLanguageChooseInOtherButton)

            // Menu activation 
        languageButton.menu = menu
        languageButton.showsMenuAsPrimaryAction = true
        languageButton.changesSelectionAsPrimaryAction = true

        recognizeButtonLanguage(firstLanguageButton, codeLanguage: sourceLanguage)
        recognizeButtonLanguage(secondLanguageButton, codeLanguage: targetLanguage)

        print("✅ the title of button language -> \(languageButton.currentTitle ?? "nothing")")
    }
}
