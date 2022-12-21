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
    let countryCodeByLanguage = ["french" : ["FR", "LU", "MO"],
                                 "english" : ["GB", "US", "AU", "BZ", "CB", "IE", "JM", "NZ", "PH", "ZA", "TT", "ZW"],
                                 "italian" : ["IT"],
                                 "spanish" : ["ES", "AR", "BO", "CL", "CO", "CR", "DO", "EC", "SV", "GT", "HN", "MX", "NI", "PA", "PY", "PE", "PR", "UY", "VE"],
                                 "portuguese" : ["PT", "BR"],
                                 "bulgarian" : ["BG"],
                                 "chinese" : ["CN", "HK", "MO", "SG", "TW"],
                                 "czech" : ["CZ"],
                                 "danish" : ["DK"],
                                 "dutch" : ["NL", "BE"],
                                 "german" : ["DE", "AT", "LI", "CH"],
                                 "greek" : ["GR"],
                                 "estonian" : ["EE"],
                                 "finnish" : ["FI"],
                                 "hungarian" : ["HU"],
                                 "indonesian" : ["ID"],
                                 "japanese" : ["JP"],
                                 "lithuanian" : ["LT"],
                                 "latvian" : ["LV"],
                                 "polish" : ["PL"],
                                 "romanian" : ["RO"],
                                 "russian" : ["RU"],
                                 "slovak" : ["SK"],
                                 "slovenian" : ["SL"],
                                 "swedish" : ["SE"],
                                 "turkish" : ["TR"],
                                 "ukrainian" : ["UA"]
    ]


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

            // language user
        titleFirstLanguage = foundMyLanguageCode(with: user.countryCode.uppercased())
        firstLanguageButton.setTitle(titleFirstLanguage, for: .normal)
        guard let sourceCode = Language(rawValue: titleFirstLanguage) else { return }
        sourceLanguage = sourceCode.code

            // language destination
        titleSecondLanguage = foundMyLanguageCode(with: destination.countryCode.uppercased())
        secondLanguageButton.setTitle(titleSecondLanguage, for: .normal)
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

    private func foundMyLanguageCode(with countryCode: String) -> String {
            // recover language code
        var currentLanguage = ""
        let languageIndex = countryCodeByLanguage.firstIndex(where: { $0.value.contains(where: {$0 == countryCode})})
        if let index = languageIndex {
            currentLanguage = countryCodeByLanguage[index].key.capitalized
            print("✅ TRANSLATE: the found language -> \(countryCodeByLanguage[index].key.capitalized)")
        } else {
            currentLanguage = "English"
            print("✅ TRANSLATE: No language found!")
        }

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
