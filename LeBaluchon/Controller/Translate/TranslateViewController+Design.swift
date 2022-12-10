//
//  TranslateViewController+Design.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 08/12/2022.
//

import Foundation
import UIKit

extension TranslateViewController {

    func setupTranslate() {
        setupTextView(baseTextView, language: Language(rawValue: titleFirstLanguage) ?? .czech)
        setupTextView(translateTextView, language: Language(rawValue: titleSecondLanguage) ?? .ukrainian)
    }

    private func setupTextView(_ textView: UITextView, language: Language) {
        textView.layer.cornerRadius = 10
        textView.delegate = self
        textView.font = UIFont(name: "HelveticaNeue", size: 25)
        textView.textColor = .pinkGranada
        guard let imageBackground = UIImage(named: language.image) else { return }
        textView.layer.contents = imageBackground.cgImage
    }

    func setupWriteButton() {
        baseTextView.text = ""
        hiddenView(baseText: false, translatedText: false, micro: true, camera: true)
        baseTextView.isEditable = true
    }

    func setupSpeechButton() {
        baseTextView.text = ""
        hiddenView(baseText: false, translatedText: false, micro: false, camera: true)
        baseTextView.isEditable = false
    }

    func setupCameraButton() {
        baseTextView.text = ""
        hiddenView(baseText: true, translatedText: false, micro: true, camera: false)
        cameraImageView.layer.cornerRadius = 10
        cameraImageView.image = nil
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
}
