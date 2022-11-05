//
//  WelcomeViewController.swift
//  LeBaluchon
//
//  Created by Greg-Mini on 11/10/2022.
//

import UIKit

class WelcomeViewController: UIViewController {

    var helloWithName: String = ""
    var myDestination: String = ""

    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()


        helloLabel.text = "\(helloWithName), what's up!"

        destinationLabel.font = UIFont(name: "NexaRustSlab-BlackShadow01", size: 35)
        destinationLabel.text = myDestination.uppercased()

    }
}
