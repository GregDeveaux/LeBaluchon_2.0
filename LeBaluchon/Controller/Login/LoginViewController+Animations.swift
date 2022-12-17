////
////  LoginViewController+Animations.swift
////  LeBaluchon
////
////  Created by Greg Deveaux on 29/11/2022.
////
//
//import Foundation
//import UIKit
//
//extension LoginViewController {
//
//    override func viewWillAppear(_ animated: Bool) {
//        animateTheLoginPage()
//        createAnimationIntro()
//            // bubble explanation before to enter in the app.
//        bubbleTextView.typeOn(sentence: welcomeText)
//    }
//
//
//    func animateTheLoginPage() {
//        nameTextField.isHidden = true
//        destinationTextField.isHidden = true
//        textNameLabel.isHidden = true
//        textDestinationLabel.isHidden = true
//        letsGoButton.isHidden = true
//        bubbleTextView.isHidden = true
//        SunImage.isHidden = true
//
////        SunImage.layoutIfNeeded()
////        SunImage.translatesAutoresizingMaskIntoConstraints = false
//
////        SunImage.centerXAnchor.constraint(equalTo: SunImage.superview!.centerXAnchor).isActive = true
////        SunImage.centerYAnchor.constraint(equalTo: SunImage.superview!.centerYAnchor, constant: 180).isActive = true
//
////        SunImage.center = SunImage.superview!.center
//
////        SunImage.heightAnchor.constraint(equalToConstant: 430).isActive = true
////        SunImage.widthAnchor.constraint(equalToConstant: 470).isActive = true
//
//    }
//
//    func createImageView(image: String, width: CGFloat, height: CGFloat) -> UIImageView {
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
//        imageView.image = UIImage(named: image)
//        imageView.adjustsImageSizeForAccessibilityContentSizeCategory = false
//        return imageView
//    }
//
//    func createAnimationIntro() {
//
//        let sunPersonna = createImageView(image: "perso1", width: 320, height: 350)
//        let bubble = createImageView(image: "bubbleToTalk", width: 200, height: 200)
//
//        sunPersonna.center = view.center
//
//        let bubbleText = UITextView()
//        bubbleText.text = welcomeText
//
//
////        view.addSubview(sunPersonna)
////        view.addSubview(bubble)
//        view.addSubview(bubbleText)
//
//        sunPersonna.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//
////        sunPersonna.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
////        sunPersonna.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//////        sunPersonna.bottomAnchor.constraint(equalTo: SafeAreaInsets.bottom)
//
//        let animator = UIViewPropertyAnimator(duration: 50, dampingRatio: 1) {
//            bubble.transform = CGAffineTransform(translationX: 0, y: -20)
//            sunPersonna.transform = CGAffineTransform(translationX: 0, y: 400)
//        }
//        animator.startAnimation()
//    }
//}
