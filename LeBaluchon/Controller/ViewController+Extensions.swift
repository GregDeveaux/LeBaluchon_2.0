//
//  ViewController+Extension.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 10/12/2022.
//

import UIKit

extension UIViewController {

        // -------------------------------------------------------
        //MARK: - alert
        // -------------------------------------------------------

    func presentAlert(message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alertVC, animated: true)
    }

    func loader() -> UIAlertController {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        indicator.hidesWhenStopped = true
        alert.view?.addSubview(indicator)
        self.present(alert, animated: true)

        return alert
    }

    func stopLoader(loader: UIAlertController) {
        DispatchQueue.main.async {
            loader.dismiss(animated: true)
        }
    }

}
