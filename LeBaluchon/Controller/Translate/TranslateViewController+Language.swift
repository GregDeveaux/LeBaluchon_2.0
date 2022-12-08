//
//  TranslateViewController+Language.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 19/11/2022.
//

import UIKit

extension TranslateViewController {

        // -------------------------------------------------------
        // MARK: - menu roll select language
        // -------------------------------------------------------

    func setupActionsMenu(of languageButton: UIButton, localeLanguage: String, codeLanguage: String) {

            // Create different pieces of menu
        let french = UIAction(title: Language.French.rawValue, state: .off) { _ in
            self.recognizeButtonLanguageTapped(languageButton, codeLanguage:  Language.French.code)
        }

        let english = UIAction(title: Language.English.rawValue, state: .off) { _ in
            self.recognizeButtonLanguageTapped(languageButton, codeLanguage: Language.English.code)
        }

        let italian = UIAction(title: Language.Italian.rawValue, state: .off) { _ in
            self.recognizeButtonLanguageTapped(languageButton, codeLanguage: Language.Italian.code)
        }

        let spanish = UIAction(title: Language.Spanish.rawValue, state: .off) { _ in
            self.recognizeButtonLanguageTapped(languageButton, codeLanguage: Language.Spanish.code)
        }

        let portuguese = UIAction(title: Language.Portuguese.rawValue, state: .off) { _ in
            self.recognizeButtonLanguageTapped(languageButton, codeLanguage: Language.Portuguese.code)
        }

        let bulgarian = UIAction(title: Language.Bulgarian.rawValue, state: .off) { _ in
            self.recognizeButtonLanguageTapped(languageButton, codeLanguage: Language.Bulgarian.code)
        }

        let chinese = UIAction(title: Language.Chinese.rawValue, state: .off) { _ in
            self.recognizeButtonLanguageTapped(languageButton, codeLanguage: Language.Chinese.code)
        }

        let czech = UIAction(title: Language.Czech.rawValue, state: .off) { _ in
            self.recognizeButtonLanguageTapped(languageButton, codeLanguage: Language.Czech.code)
        }

        let danish = UIAction(title: Language.Danish.rawValue, state: .off) { _ in
            self.recognizeButtonLanguageTapped(languageButton, codeLanguage: Language.Danish.code)
        }

        let dutch = UIAction(title: Language.Dutch.rawValue, state: .off) { _ in
            self.recognizeButtonLanguageTapped(languageButton, codeLanguage: Language.Dutch.code)
        }

        let german = UIAction(title: Language.German.rawValue, state: .off) { _ in
            self.recognizeButtonLanguageTapped(languageButton, codeLanguage: Language.German.code)
        }

        let greek = UIAction(title: Language.Greek.rawValue, state: .off) { _ in
            self.recognizeButtonLanguageTapped(languageButton, codeLanguage: Language.Greek.code)
        }

        let estonian = UIAction(title: Language.Estonian.rawValue, state: .off) { _ in
            self.recognizeButtonLanguageTapped(languageButton, codeLanguage: Language.Estonian.code)
        }

        let finnish = UIAction(title: Language.Finnish.rawValue, state: .off) { _ in
            self.recognizeButtonLanguageTapped(languageButton, codeLanguage: Language.Finnish.code)
        }

        let hungarian = UIAction(title: Language.Hungarian.rawValue, state: .off) { _ in
            self.recognizeButtonLanguageTapped(languageButton, codeLanguage: Language.Hungarian.code)
        }

        let indonesian = UIAction(title: Language.Indonesian.rawValue, state: .off) { _ in
            self.recognizeButtonLanguageTapped(languageButton, codeLanguage: Language.Indonesian.code)
        }

        let japanese = UIAction(title: Language.Japanese.rawValue, state: .off) { _ in
            self.recognizeButtonLanguageTapped(languageButton, codeLanguage: Language.Japanese.code)
        }

        let lithuanian = UIAction(title: Language.Lithuanian.rawValue, state: .off) { _ in
            self.recognizeButtonLanguageTapped(languageButton, codeLanguage: Language.Lithuanian.code)
        }

        let latvian = UIAction(title: Language.Latvian.rawValue, state: .off) { _ in
            self.recognizeButtonLanguageTapped(languageButton, codeLanguage: Language.Latvian.code)
        }

        let polish = UIAction(title: Language.Polish.rawValue, state: .off) { _ in
            self.recognizeButtonLanguageTapped(languageButton, codeLanguage: Language.Polish.code)
        }

        let romanian = UIAction(title: Language.Romanian.rawValue, state: .off) { _ in
            self.recognizeButtonLanguageTapped(languageButton, codeLanguage: Language.Romanian.code)
        }

        let russian = UIAction(title: Language.Russian.rawValue, state: .off) { _ in
            self.recognizeButtonLanguageTapped(languageButton, codeLanguage: Language.Russian.code)
        }

        let slovak = UIAction(title: Language.Slovak.rawValue, state: .off) { _ in
            self.recognizeButtonLanguageTapped(languageButton, codeLanguage: Language.Slovak.code)
        }

        let slovenian = UIAction(title: Language.Slovenian.rawValue, state: .off) { _ in
            self.recognizeButtonLanguageTapped(languageButton, codeLanguage: Language.Slovenian.code)
        }

        let swedish = UIAction(title: Language.Swedish.rawValue, state: .off) { _ in
            self.recognizeButtonLanguageTapped(languageButton, codeLanguage: Language.Swedish.code)
        }

        let turkish = UIAction(title: Language.Turkish.rawValue, state: .off) { _ in
            self.recognizeButtonLanguageTapped(languageButton, codeLanguage: Language.Turkish.code)
        }

        let ukrainian = UIAction(title: Language.Ukrainian.rawValue, state: .off) { _ in
            self.recognizeButtonLanguageTapped(languageButton, codeLanguage: Language.Ukrainian.code)
        }

        let actions: [UIAction] = [french, english, italian, spanish, portuguese, bulgarian, chinese, czech, danish, dutch,
                                   german, greek, estonian, finnish, hungarian, indonesian, japanese, lithuanian, latvian,
                                   polish, romanian, russian, slovak, slovenian, swedish, turkish, ukrainian]

        if let index = actions.firstIndex(where: {languageButton.currentTitle == $0.title}) {
            actions[index].state = .on
        }

//        let actionsWithdeleteLanguageChooseInOtherButton = actions.filter({$0.title != currentTitleOtherButton})

        let menu = UIMenu(identifier: .text, options: .singleSelection, children: actions)

            // Menu activation
        languageButton.menu = menu
        languageButton.showsMenuAsPrimaryAction = true
        languageButton.changesSelectionAsPrimaryAction = true

        print("✅ the title of button language -> 🎟 \(languageButton.currentTitle ?? "nothing")")
    }
}
