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


}
