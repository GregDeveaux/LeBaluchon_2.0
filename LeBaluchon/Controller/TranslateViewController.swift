//
//  TranslateViewController.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 10/10/2022.
//

import UIKit

class TranslateViewController: UIViewController {

    @IBOutlet weak var baseTextView: UITextView!
    @IBOutlet weak var translateTextView: UITextView!

    @IBOutlet weak var firstLanguageButton: UIButton!
    @IBOutlet weak var secondLanguageButton: UIButton!
    @IBOutlet weak var switchButton: UIButton!

    var textToTanslate = ""
    var textTranslated = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTranslate()
    }

    private func setupTranslate() {
        setupTextView(baseTextView)
        setupTextView(translateTextView)

        textToTanslate = baseTextView.text
    }

    private func setupTextView(_ textView: UITextView) {
        textView.layer.cornerRadius = 10
        textView.delegate = self
    }

    private func setupActionMenu(_ languageButton: UIButton) {

        languageButton.changesSelectionAsPrimaryAction = true
        languageButton.showsMenuAsPrimaryAction = true

//        let wholeLanguage = {(action: UIAction) in

//        }

    }

}

extension TranslateViewController: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        if text == "\n" {
                textView.resignFirstResponder()
                return false
            }

        return true
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        baseTextView.text = ""
        baseTextView.textColor = .pinkGranada
        baseTextView.usesStandardTextScaling = true

        baseTextView.enablesReturnKeyAutomatically = true
    }

    func textViewDidChange(_ textView: UITextView) {
        print("le texte change")
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        if baseTextView.text.isEmpty {
            baseTextView.text = "Écris un mot ou une phrase à traduire ici"
            baseTextView.textColor = .lightGray
        }

        if baseTextView.text!.contains(" ") {
            API.QueryService.shared.getTranslate(endpoint: .translation(sourceLang: "FR", text: baseTextView.text, targetLang: "EN"), method: .POST) { success, recover in
                guard let recover = recover, success == true else {
                    print(API.Error.generic(reason: "not shown data"))
                    return
                }

                if let text = recover.translations.first?.text {
                    self.translateTextView.text = text
                }
            }
        }

        print("✅ le texte nouveau texte :\(baseTextView.text!)")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard let key = presses.first?.key else { return }

        switch key.keyCode {
            case .keyboardSpacebar:
                print("✅ space is actived")
            default:
                super.pressesBegan(presses, with: event)
        }
    }

}
