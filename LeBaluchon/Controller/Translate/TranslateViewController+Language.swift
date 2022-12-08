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

            // Create first language of menu
        let firstLanguage = UIAction(title: localeLanguage) { _ in
            self.recognizeButtonLanguageTapped(languageButton, codeLanguage: codeLanguage)
        }

            // Take the list of language of the API DeepL
        let listOfLanguages = Language.list

            // Take anarray empty for the actions menu (list of roll menu)
        var actions: [UIAction] = []

        for (key, value) in listOfLanguages {
          print("🎟 \(key): \(value)")

            let language = UIAction(title: value) { _ in
                self.recognizeButtonLanguageTapped(languageButton, codeLanguage: key)
            }
            actions.append(language)
        }

        print("🎟🎟🎟🎟🎟🎟🎟🎟 \(actions)")

        let menu = UIMenu(identifier: .text, options: .singleSelection, children: actions)

            // Menu activation 
        languageButton.menu = menu
        languageButton.showsMenuAsPrimaryAction = true
        languageButton.changesSelectionAsPrimaryAction = true

//            // Delete the first language of button
//        let newListOfLanguages = listOfLanguages.filter({$0.value != localeLanguage})


    }
}
