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
    let userDefaults = UserDefaults.standard
    let localeUser = Locale.current
    var localeDestination: Locale!


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

        let countryCode = userDefaults.string(forKey: "destinationCountryCode")
        localeDestination = Locale(identifier: countryCode ?? "BE")

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

        print("✅✅ you button first language -> \(firstLanguageButton.currentTitle ?? "Nothing")")
        print("✅✅ you button second language -> \(secondLanguageButton.currentTitle ?? "Nothing")")

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
            currentCodeLanguage = locale.language.minimalIdentifier
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

    func recordAndRecognizeSpeech() {
        guard let inputNode = audioEngine?.inputNode else { return }
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.requestAudio.append(buffer)
        }

        audioEngine?.prepare()
        do {
            try audioEngine?.start()
        } catch {
            return print(error)
        }

        guard let myRecognizer = SFSpeechRecognizer() else { return }

        if !myRecognizer.isAvailable {
            return
        }

        recognitionTask = speechRecognizer?.recognitionTask(with: requestAudio, resultHandler: { result, error in
            guard let result = result, error == nil else {
                self.presentAlert()
                print("There is not result for the voice!")
                return
            }

            let bestString = result.bestTranscription.formattedString
            self.baseTextView.text = bestString
            print("✅ The speech recorded!")
        })
    }


        // -------------------------------------------------------
        // MARK: - translation by the image
        // -------------------------------------------------------

    func recognizeText(image: UIImage?) {
        guard let cgImage = image?.cgImage else { return }

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

        let request = VNRecognizeTextRequest { request, error in
            guard let results = request.results as? [VNRecognizedTextObservation], error == nil else { return }

            let text = results.compactMap({ $0.topCandidates(1).first?.string }).joined(separator: ", ")

            DispatchQueue.main.async {
                self.baseTextView.text = text
            }
        }

        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }
}


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
                        print("🈯️ le texte traduit est \(translatedSentence)")
                    }
                }
            }
        }
        print("✅ le texte nouveau texte :\(baseTextView.text!)")
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
