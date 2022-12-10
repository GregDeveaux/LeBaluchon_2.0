//
//  WeatherDestinationViewController.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 12/10/2022.
//

import UIKit

class WeatherDestinationViewController: UIViewController {


        // -------------------------------------------------------
        // MARK: - properties
        // -------------------------------------------------------

    @IBOutlet weak var countryNameDestinationLabel: UILabel!
    @IBOutlet weak var cityNameDestinationLabel: UILabel!
    @IBOutlet weak var temperatureOfDestinationLabel: UILabel!
    @IBOutlet var unitTempDestinationLabels: [UILabel]!
    @IBOutlet weak var hightTempDayDestinationLabel: UILabel!

    @IBOutlet weak var lowTempDayDestinationLabel: UILabel!
    @IBOutlet weak var descriptionSkyDestinationLabel: UILabel!

    @IBOutlet weak var dayDestinationLabel: UILabel!
    @IBOutlet weak var hourDestinationLabel: UILabel!

    @IBOutlet weak var backgroundImageDestination: UIImageView!
    @IBOutlet weak var personnaDestinationImage: UIImageView!
    @IBOutlet weak var iconeSkyImageDestination: UIImageView!


    let userDefaults = UserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()

        let destinationCity = userDefaults.string(forKey: "destinationCityName")
        let destinationCountry = userDefaults.string(forKey: "destinationCountry")

        let dataController = WeatherHomeViewController()
        dataController.myDelegate = self

        cityNameDestinationLabel.text = destinationCity
        countryNameDestinationLabel.text = destinationCountry
    }


        // -------------------------------------------------------
        // MARK: - modify images of ViewController
        // -------------------------------------------------------

    private func giveMeTheWeatherImages(weatherImages: [String], background: UIImageView, description: UIImageView, personnaImage: UIImageView) {
        background.image = UIImage(named: weatherImages[0])
        description.image = UIImage(systemName: weatherImages[1])
        if weatherImages[1] == "sun.max.fill" {
            description.tintColor = .yellow
        }
        personnaImage.image = UIImage(named: weatherImages[2])
    }


        // -------------------------------------------------------
        // MARK: - format date
        // -------------------------------------------------------

    private func giveMeTheDate(_ date: Int) -> (dayLabel: String?, hourLabel: String?) {
        let todayDate = Date(timeIntervalSinceReferenceDate: TimeInterval(date))

        let formatterHour = DateFormatter()
        formatterHour.timeStyle = .short
        print("✅ date of destination: \(formatterHour.string(from: todayDate))")

        let formatterDay = DateFormatter()
        formatterDay.dateFormat = "EEEE, d"
        print("✅ hour of destination:  \(formatterDay.string(from: todayDate))")

        let dayLabel = formatterDay.string(from: todayDate)
        let hourLabel = formatterHour.string(from: todayDate)

        return (dayLabel, hourLabel)
    }

    private func presentAlert() {
        let alertVC = UIAlertController(title: "Error", message: "The weather system failed", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alertVC, animated: true)
    }
}


    // -------------------------------------------------------
    // MARK: - use API Weather, recover info
    // -------------------------------------------------------

extension WeatherDestinationViewController: WeatherDestinationDelegate {

    func rescueTheTemperatures(today temperature: String, hightTemperature: String, lowTemperature: String, unit: String) {
            self.temperatureOfDestinationLabel.text = temperature
            self.hightTempDayDestinationLabel.text = hightTemperature
            self.lowTempDayDestinationLabel.text = lowTemperature
    }

    func rescueTheImages(background: UIImage, icone: UIImage, personna: UIImage) {
        self.backgroundImageDestination.image = background
        self.iconeSkyImageDestination.image = icone
        self.personnaDestinationImage.image = personna
    }

    func rescueTheDate(day: String, hour: String) {
        self.dayDestinationLabel.text = day
        self.hourDestinationLabel.text = hour
    }

}
