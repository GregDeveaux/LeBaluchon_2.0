//
//  LoginViewController+Animations.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 29/11/2022.
//

import Foundation
import UIKit

extension LoginViewController {

    override func viewWillAppear(_ animated: Bool) {
        animateTheLoginPage()
        createViewContainer()
    }

    func animateTheLoginPage() {
        nameTextField.isHidden = true
        destinationTextField.isHidden = true
        textNameLabel.isHidden = true
        textDestinationLabel.isHidden = true
        LetsGoButton.isHidden = true
        bubbleTextView.isHidden = true
        SunImage.isHidden = true

//        SunImage.layoutIfNeeded()
//        SunImage.translatesAutoresizingMaskIntoConstraints = false
//        SunImage.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        SunImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
//        SunImage.centerXAnchor.constraint(equalTo: SunImage.superview!.centerXAnchor).isActive = true
//        SunImage.centerYAnchor.constraint(equalTo: SunImage.superview!.centerYAnchor, constant: 180).isActive = true

//        SunImage.center = SunImage.superview!.center

//        SunImage.heightAnchor.constraint(equalToConstant: 430).isActive = true
//        SunImage.widthAnchor.constraint(equalToConstant: 470).isActive = true

    }

    func createImageView(image: String, width: CGFloat, height: CGFloat) -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: image))
        imageView.frame.size.width = width
        imageView.frame.size.height = height
        imageView.center = self.view.center

        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }

    func createViewContainer() {
        let container = UIView()
        container.backgroundColor = .yellow
        container.frame.size.width = 380
        container.frame.size.height = 600

        container.translatesAutoresizingMaskIntoConstraints = false
        container.center = view.center


        view.addSubview(container)

        let redBox = UIView(frame: CGRect(x: -64, y: 0, width: 128, height: 128))
        redBox.translatesAutoresizingMaskIntoConstraints = false
        redBox.backgroundColor = UIColor.red
        redBox.center.y = view.center.y
        view.addSubview(redBox)

        let sunPersonna = createImageView(image: "perso1.pdf", width: 351, height: 373)
        let bubble = createImageView(image: "bubbleToTalk.pdf", width: 200, height: 166)

        container.addSubview(sunPersonna)
        container.addSubview(bubble)

        let animator = UIViewPropertyAnimator(duration: 5, dampingRatio: 1) {
            container.transform = CGAffineTransform(rotationAngle: CGFloat.pi).scaledBy(x: 0.001, y: 0.001)
            sunPersonna.transform = CGAffineTransform(translationX: 0, y: 200)
        }
        animator.startAnimation()
    }
}
