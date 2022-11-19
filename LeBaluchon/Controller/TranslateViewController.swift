//
//  TranslateViewController.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 10/10/2022.
//

import UIKit

class TranslateViewController: UIViewController {

        // -------------------------------------------------------
        //MARK: - properties init
        // -------------------------------------------------------

        // Blocks text
    @IBOutlet weak var baseTextView: UITextView!
    @IBOutlet weak var translateTextView: UITextView!

        // Buttons languages
    @IBOutlet weak var firstLanguageButton: UIButton!
    @IBOutlet weak var secondLanguageButton: UIButton!
    @IBOutlet weak var switchButton: UIButton!

        // Buttons method of translation
    @IBOutlet weak var writeButton: UIButton!
    @IBOutlet weak var speechButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!

        // StackView of blocks text to modify spacing
    @IBOutlet weak var whiteBoardOfTranslateStackView: UIStackView!

        // Image for the design
    @IBOutlet weak var handWithMicroImage: UIImageView!

        // Block camera
    @IBOutlet weak var cameraImageView: UIImageView!

        // create a new image view for the translation by camera
    var editingImage: UIImageView!

    var textToTanslate = ""
    var textTranslated = ""

    var sourceLanguage = "EN"
    var targetLanguage = "FR"


        // -------------------------------------------------------
        //MARK: - viewDidLoad
        // -------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTranslate()
        setupButtonsLanguage()
    }


        // -------------------------------------------------------
        // MARK: - setups
        // -------------------------------------------------------

    private func setupTranslate() {
        setupTextView(baseTextView)
        setupTextView(translateTextView)

        textToTanslate = baseTextView.text
        baseTextView.text = textTranslated
    }

    private func setupTextView(_ textView: UITextView) {
        textView.layer.cornerRadius = 10
        textView.delegate = self

        textView.font = UIFont(name: "HelveticaNeue", size: 25)
        textView.textColor = .pinkGranada
    }

    private func setupWriteButton() {
        hiddenView(baseText: false, translatedText: false, micro: true, camera: true)
        baseTextView.isEditable = true
        whiteBoardOfTranslateStackView.spacing = 30
    }

    private func setupSpeechButton() {
        hiddenView(baseText: false, translatedText: false, micro: false, camera: true)
        baseTextView.isEditable = false
        whiteBoardOfTranslateStackView.spacing = 200
    }

    private func setupCameraButton() {
        hiddenView(baseText: true, translatedText: true, micro: true, camera: false)
        cameraImageView.layer.cornerRadius = 10
    }

    func setupButtonsLanguage() {
        setupActionsMenu(of: firstLanguageButton, currentTitleOtherButton: secondLanguageButton.currentTitle ?? "")
        setupActionsMenu(of: secondLanguageButton, currentTitleOtherButton: firstLanguageButton.currentTitle ?? "")

        print("✅ you chose first language -> \(sourceLanguage)")
        print("✅ you chose second language -> \(targetLanguage)")
    }


        // -------------------------------------------------------
        // MARK: - Buttons to choose the method of translation
        // -------------------------------------------------------

    @IBAction func tappedWriteButton(_ sender: UIButton) {
        setupWriteButton()
    }
    
    @IBAction func tappedSpeechButton(_ sender: UIButton) {
        setupSpeechButton()
    }

    @IBAction func tappedCameraButton(_ sender: UIButton) {
        setupCameraButton()
        chooseNewImage()
        cameraImageView = editingImage
    }

    private func hiddenView(baseText: Bool, translatedText: Bool, micro: Bool, camera: Bool) {
        baseTextView.isHidden = baseText
        translateTextView.isHidden = translatedText
        handWithMicroImage.isHidden = micro
        handWithMicroImage.layer.shadowColor = UIColor.black.cgColor
        handWithMicroImage.layer.shadowOpacity = 0.3
        handWithMicroImage.layer.shadowOffset = CGSize(width: 15, height: 15)
        handWithMicroImage.layer.shadowRadius = 5
        cameraImageView.isHidden = camera
    }


        // -------------------------------------------------------
        //MARK: - Buttons language
        // -------------------------------------------------------

    @IBAction func tappedToSwitchLanguage(_ sender: UIButton) {
        swap(&firstLanguageButton, &secondLanguageButton)
    }

    func recognizeButtonLanguage(_ languageButton: UIButton, codeLanguage: String) {
        if languageButton == self.firstLanguageButton {
            self.sourceLanguage = codeLanguage
        } else {
            self.targetLanguage = codeLanguage
        }
    }
}

extension TranslateViewController: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        return true
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        baseTextView.text = ""
        baseTextView.usesStandardTextScaling = true

        baseTextView.enablesReturnKeyAutomatically = true
    }

    func textViewDidChange(_ textView: UITextView) {
        print("the text changes")
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        if baseTextView.text.isEmpty {
            baseTextView.text = "Write a word or phrase to translate here"
            baseTextView.textColor = .lightGray
        }

        API.QueryService.shared.getTranslate(endpoint: .translation(sourceLang: sourceLanguage, text: baseTextView.text, targetLang: targetLanguage), method: .POST) { success, recover in
            guard let recover = recover, success == true else {
                print(API.Error.generic(reason: "not shown data"))
                return
            }

            if let text = recover.translations.first?.text {
                self.translateTextView.text = text
            }
        }

        print("✅ le texte nouveau texte :\(baseTextView.text!)")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}
