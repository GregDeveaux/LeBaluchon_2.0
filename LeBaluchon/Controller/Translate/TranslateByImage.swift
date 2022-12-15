//
//  TranslateByImage.swift
//  LeBaluchon
//
//  Created by Greg-Mini on 14/12/2022.
//

import UIKit
import Vision

extension TranslateViewController {
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

