//
//  ViewController.swift
//  LeBaluchon
//
//  Created by Greg-Mini on 10/10/2022.
//

import UIKit

class WeatherHomeViewController: UIViewController {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var degresLabel: UILabel!
    @IBOutlet weak var unitTempLabels: UILabel!
    @IBOutlet weak var hightTempDayLabel: UILabel!
    @IBOutlet weak var lowTempDayLabel: UILabel!
    @IBOutlet weak var descriptionSkyLabel: UILabel!
    @IBOutlet weak var descriptionSkyImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        showSheetWeatherDestination()

    }


    private func showSheetWeatherDestination() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let weatherDestinationViewController = storyboard.instantiateViewController(withIdentifier: "weatherDestinationViewController")

        weatherDestinationViewController.modalPresentationStyle = .pageSheet

        if let sheet = weatherDestinationViewController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]

            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersGrabberVisible = true
            sheet.accessibilityElementsHidden = false
        }

        present(weatherDestinationViewController, animated: true)
    }


    @IBAction func tappedForWeather(_ sender: Any) {
        API.QueryService.shared.getWeather(endpoint: .weather(city: "Lille", units: "metric"), method: .GET) { success, weatherForCity in
            guard let weatherForCity = weatherForCity, success == true else {
                print(API.Error.generic(reason: "not shown data"))
                return
            }
            self.cityLabel.text = String(weatherForCity.name)

            self.degresLabel.text = String(Int(weatherForCity.main.temp))
            self.hightTempDayLabel.text = String(Int(weatherForCity.main.tempMax))
            self.lowTempDayLabel.text = String(Int(weatherForCity.main.tempMin))

            if let description = weatherForCity.weather.first?.description {
                self.descriptionSkyLabel.text = description
            }

        }
        
    }
}
