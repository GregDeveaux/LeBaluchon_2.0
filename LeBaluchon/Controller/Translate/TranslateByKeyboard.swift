//
//  TranslateByKeyboard.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 14/12/2022.
//

import UIKit

    // -------------------------------------------------------
    // MARK: - translation by the keyboard
    // -------------------------------------------------------
    // (used also for voice and image)

extension TranslateViewController: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        baseTextView.text = ""
        baseTextView.usesStandardTextScaling = true
        baseTextView.enablesReturnKeyAutomatically = true
    }

    func textViewDidChangeSelection(_ textView: UITextView) {

        guard let sentence = baseTextView.text else { return }

        API.QueryService.shared.getData(endpoint: .translation(sourceLang: sourceLanguage, text: sentence, targetLang: targetLanguage),
                                        method: .POST,
                                        type: API.Translation.Recover.self) { result in
            switch result {
                case .failure(let error):
                    print(error.localizedDescription)

                case .success(let result):
                    DispatchQueue.main.async {
                        if let translatedSentence = result.translations.first?.text {
                            self.translateTextView.text = translatedSentence
                        print("🈯️ TRANSLATE KEYBOARD: le texte traduit est \(translatedSentence)")
                    }
                }
            }
        }
        print("✅ TRANSLATE KEYBOARD: le texte a traduire est :\(baseTextView.text!)")
    }

    private func presentAlert() {
        let alertVC = UIAlertController(title: "Error", message: "The result of translation failed", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alertVC, animated: true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
