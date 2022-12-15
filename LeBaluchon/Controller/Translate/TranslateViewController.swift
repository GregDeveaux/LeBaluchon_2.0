//
//  TranslateViewController.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 10/10/2022.
//

import UIKit
import Speech
import Vision

class TranslateViewController: UIViewController {

        // -------------------------------------------------------
        // MARK: properties
        // -------------------------------------------------------

    var user = User()
    var destination = Destination()

        // create a new image view for the translation by camera
    var editingImage: UIImageView!

        // init source and target language
    var sourceLanguage = ""
    var targetLanguage = ""
    var titleFirstLanguage = ""
    var titleSecondLanguage = ""

        // create a properties for speech voice
    let audioEngine: AVAudioEngine? = AVAudioEngine()
    let speechRecognizer:SFSpeechRecognizer? = SFSpeechRecognizer()
    let requestAudio = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?

        // recover language record in the iPhone
    let localeUser = Locale.current
    var localeDestination: Locale!


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

        // Image for the design
    @IBOutlet weak var buttonForMicro: UIButton!
    @IBOutlet weak var handWithMicroImage: UIImageView!

        // Block camera
    @IBOutlet weak var cameraImageView: UIImageView!


        // -------------------------------------------------------
        // MARK: - viewDidLoad
        // -------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupInitFirstLanguages()
        setupTranslate()
    }


        // -------------------------------------------------------
        // MARK: - setups
        // -------------------------------------------------------

    func setupInitFirstLanguages() {

        localeDestination = Locale(identifier: destination.countryCode)

            // language user
        titleFirstLanguage = foundMyLanguageCode(with: localeUser)
        firstLanguageButton.setTitle(titleFirstLanguage, for: .normal)
        guard let sourceCode = Language(rawValue: titleFirstLanguage) else { return }
        sourceLanguage = sourceCode.code

            // language destination
        titleSecondLanguage = foundMyLanguageCode(with: localeDestination)
        secondLanguageButton.setTitle(titleSecondLanguage, for: .normal)
        print("✅✅✅ you 2de -> \(String(describing: localeDestination)) ✅✅✅")
        print("✅✅✅ you 2de -> \(titleSecondLanguage) ✅✅✅")
        guard let targetCode = Language(rawValue: titleSecondLanguage) else { return }
        targetLanguage = targetCode.code

        print("✅ TRANSLATE INIT: you button first language -> \(firstLanguageButton.currentTitle ?? "Nothing")")
        print("✅ TRANSLATE INIT: you button second language -> \(secondLanguageButton.currentTitle ?? "Nothing")")

        setupButtonsLanguage()
    }

        // roll menu with all languages
    func setupButtonsLanguage() {
        setupActionsMenu(of: firstLanguageButton)
        setupActionsMenu(of: secondLanguageButton)
    }

    private func foundMyLanguageCode(with locale: Locale) -> String {
            // recover language code
        var currentCodeLanguage = ""
        if #available(iOS 16, *) {
            currentCodeLanguage = locale.language.maximalIdentifier
            print("✅✅✅✅✅✅ you language code -> \(currentCodeLanguage)")
        } else {
            if let localeLanguageCode = locale.languageCode {
                currentCodeLanguage = localeLanguageCode
            }
        }
        let currentLocale = Locale(identifier: "en_US")
            // here, we mix localeDestination/localeUser with locale English version to recover language in English version
        let currentLanguage = currentLocale.localizedString(forLanguageCode: currentCodeLanguage) ?? ""
        print("✅✅✅✅✅✅ you language -> \(currentLanguage)")

        return currentLanguage
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
    }


        // -------------------------------------------------------
        //MARK: - Buttons switch language
        // -------------------------------------------------------

    @IBAction func tappedToSwitchLanguage(_ sender: UIButton) {
        print("🅿️ \(titleFirstLanguage), \(titleSecondLanguage)")
        swap(&titleFirstLanguage, &titleSecondLanguage)
        print("Ⓜ️ \(titleFirstLanguage), \(titleSecondLanguage)")

        firstLanguageButton.setTitle(titleFirstLanguage, for: .normal)
        secondLanguageButton.setTitle(titleSecondLanguage, for: .normal)

        guard let sourceCode = Language(rawValue: titleFirstLanguage) else { return }
        sourceLanguage = sourceCode.code
        guard let targetCode = Language(rawValue: titleSecondLanguage) else { return }
        targetLanguage = targetCode.code

        setupButtonsLanguage()

        swap(&baseTextView.text, &translateTextView.text)
    }

    
        // -------------------------------------------------------
        // MARK: - translation by the voice
        // -------------------------------------------------------

    @IBAction func tappedMicroForStartWithTheVoice(_ sender: UIButton) {
        recordAndRecognizeSpeech()
    }
}
