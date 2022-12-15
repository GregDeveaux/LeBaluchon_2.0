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

    func setupActionsMenu(of languageButton: UIButton) {

            // Create an empty array actions global
        var actions: [UIAction] = []

            // Create different pieces of menu
        for language in Language.allCases {
            let language = UIAction(title: language.rawValue, state: .off) { _ in
                self.recognizeButtonLanguageTapped(languageButton, codeLanguage: language.code)
            }
            actions.append(language)
        }
            // Init the correct language at the start of the translation
        guard let index = actions.firstIndex(where: {languageButton.currentTitle == $0.title}) else { return }
        actions[index].state = .on

        var removeIndex = 0

        if languageButton.currentTitle == titleFirstLanguage {
            removeIndex = actions.firstIndex(where: {titleSecondLanguage == $0.title}) ?? removeIndex
        } else {
            removeIndex = actions.firstIndex(where: {titleFirstLanguage == $0.title}) ?? removeIndex
        }
        actions.remove(at: removeIndex)

            // Create Menu...
        let menu = UIMenu(identifier: .text, options: .singleSelection, children: actions)

            // ... and active
        languageButton.menu = menu
        languageButton.showsMenuAsPrimaryAction = true
        languageButton.changesSelectionAsPrimaryAction = true

        print("✅ the title of button language -> 🎟 \(languageButton.currentTitle ?? "nothing")")
    }

    private func recognizeButtonLanguageTapped(_ languageButton: UIButton, codeLanguage: String) {
        if languageButton == self.firstLanguageButton {
            self.sourceLanguage = codeLanguage
        } else {
            self.targetLanguage = codeLanguage
        }
    }
}
