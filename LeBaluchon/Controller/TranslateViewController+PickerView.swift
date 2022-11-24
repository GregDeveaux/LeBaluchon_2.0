//
//  TranslateViewController+PickerView.swift
//  LeBaluchon
//
//  Created by Greg-Mini on 19/11/2022.
//

import UIKit
import PhotosUI

extension TranslateViewController: PHPickerViewControllerDelegate {

    // -------------------------------------------------------
    // MARK: load the image (library or camera)
    // -------------------------------------------------------

func chooseNewImage() {
    let alert = UIAlertController(title: "Select your image", message: "the translation will trigger after image fetch", preferredStyle: .actionSheet)

        // Modify the color text
    alert.view.tintColor = .pinkFlash

        // Share photoLibrary for images
    alert.addAction(UIAlertAction(title: "Photo Gallery", style: .default, handler: { (_) in
        self.present(self.pickerPH, animated: true)
    }))

        // Share camera for images
    alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
        self.present(self.pickerUI, animated: true)
    }))

        // If the user doesn't want to share the image
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        // show the alert and animation of the sheet
    present(alert, animated: true)
}

    // -------------------------------------------------------
    // MARK: picker image library
    // -------------------------------------------------------

        // create a picker controller to load the images from photo library
    var pickerPH: PHPickerViewController {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        let pickerPH = PHPickerViewController(configuration: configuration)
        pickerPH.delegate = self

        if let sheet = pickerPH.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.preferredCornerRadius = 25.0
        }
        return pickerPH
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if let sheet = pickerPH.sheetPresentationController {
            sheet.animateChanges {
                sheet.selectedDetentIdentifier = .medium
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            }
        }

        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            let previousImage = editingImage?.image
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                DispatchQueue.main.sync {
                    guard let self = self, let chosenImage = image as? UIImage,
                              self.editingImage?.image == previousImage else { return }
                    self.editingImage?.image = chosenImage
                }
            }
        }
        print("✅ your image -> \(String(describing: editingImage?.image))")

        dismiss(animated: true)
    }
}


    // -------------------------------------------------------
    // MARK: picker camera
    // -------------------------------------------------------

extension TranslateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        // create a picker controller to load the images from camera
    var pickerUI: UIImagePickerController {
        let pickerUI = UIImagePickerController()
        pickerUI.allowsEditing = true
        pickerUI.sourceType = .camera
        pickerUI.cameraCaptureMode = .photo
        pickerUI.modalPresentationStyle = .currentContext
        pickerUI.delegate = self
        return pickerUI
    }

        // recover the image and applied a fullscreen
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let chosenImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            print("No image found")
            return
        }

        editingImage?.image = chosenImage
        print("✅ your image -> \(String(describing: editingImage?.image))")

        dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

