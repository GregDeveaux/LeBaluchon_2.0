//
//  TranslateByVoice.swift
//  LeBaluchon
//
//  Created by Greg-Mini on 14/12/2022.
//

import UIKit
import Speech

extension TranslateViewController {

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
                self.presentAlert(message: "There is not result for the voice!")
                return
            }

            let bestString = result.bestTranscription.formattedString
            self.baseTextView.text = bestString
            print("✅ The speech recorded!")
        })
    }

}
