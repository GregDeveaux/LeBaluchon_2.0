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
    var sourceLanguage = "EN"
    var targetLanguage = "FR"

        // create a properties for speech voice
    let audioEngine: AVAudioEngine? = AVAudioEngine()
    let speechRecognizer:SFSpeechRecognizer? = SFSpeechRecognizer()
    let requestAudio = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?

        // recover language record in the iPhone
    let userDefaults = UserDefaults.standard
    let localeUser = Locale.current

//    lazy var languageUser: String = {
//        var languageUser: String
//        if #available(iOS 16, *) {
//            languageUser = localeUser.localizedString(forLanguageCode: localeUser.language.minimalIdentifier) ?? ""
//        } else {
//            languageUser = Locale.preferredLanguages[0]
//        }
//        print("💠 you chose first language -> \(languageUser)")
//        return languageUser
//    }()
//
//    lazy var languageDestination: String = {
//        var localDestination = Locale()
//
//        guard let languageDestination: String else { return }
//
//        let regionICodeDestination = localDestination.localizedString(forRegionCode: userDefaults.string(forKey: "destinationCountry")?.uppercased() ?? "BELGIUM")
//        languageDestination = localDestination.localizedString(forLanguageCode: regionICodeDestination)
//        print("💠 you chose second language -> \(languageDestination)")
//        return languageDestination
//    }()


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
    }

    private func setupTextView(_ textView: UITextView) {
        textView.layer.cornerRadius = 10
        textView.delegate = self
        textView.font = UIFont(name: "HelveticaNeue", size: 25)
        textView.textColor = .pinkGranada
    }

    private func setupWriteButton() {
        baseTextView.text = ""
        hiddenView(baseText: false, translatedText: false, micro: true, camera: true)
        baseTextView.isEditable = true
    }

    private func setupSpeechButton() {
        baseTextView.text = ""
        hiddenView(baseText: false, translatedText: false, micro: false, camera: true)
        baseTextView.isEditable = false
    }

    private func setupCameraButton() {
        baseTextView.text = ""
        hiddenView(baseText: true, translatedText: false, micro: true, camera: false)
        cameraImageView.layer.cornerRadius = 10
        cameraImageView.image = nil
    }

    func setupButtonsLanguage() {
        setupActionsMenu(of: firstLanguageButton, currentTitleOtherButton: secondLanguageButton.currentTitle ?? "")
        setupActionsMenu(of: secondLanguageButton, currentTitleOtherButton: firstLanguageButton.currentTitle ?? "")
        print("✅ you chose first language -> \(sourceLanguage)")
        print("✅ you chose second language -> \(targetLanguage)")
    }

    private func hiddenView(baseText: Bool, translatedText: Bool, micro: Bool, camera: Bool) {
        baseTextView.isHidden = baseText
        translateTextView.isHidden = translatedText
        handWithMicroImage.isHidden = micro
        buttonForMicro.isHidden = micro
        handWithMicroImage.layer.shadowColor = UIColor.black.cgColor
        handWithMicroImage.layer.shadowOpacity = 0.3
        handWithMicroImage.layer.shadowOffset = CGSize(width: 15, height: 15)
        handWithMicroImage.layer.shadowRadius = 5
        cameraImageView.isHidden = camera

        baseTextView.backgroundColor = .white
        baseTextView.overrideUserInterfaceStyle = .light
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
        //MARK: - Buttons language
        // -------------------------------------------------------

    @IBAction func tappedToSwitchLanguage(_ sender: UIButton) {
        swap(&sourceLanguage, &targetLanguage)
        firstLanguageButton.setTitle(sourceLanguage, for: .normal)
        secondLanguageButton.setTitle(targetLanguage, for: .normal)
    }

    func recognizeButtonLanguage(_ languageButton: UIButton, codeLanguage: String) {
        if languageButton == self.firstLanguageButton {
            self.sourceLanguage = codeLanguage
        } else {
            self.targetLanguage = codeLanguage
        }
    }

    @IBAction func tappedMicroForStartWithTheVoice(_ sender: UIButton) {
        recordAndRecognizeSpeech()
    }


        // -------------------------------------------------------
        // MARK: - translation by the voice
        // -------------------------------------------------------

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
