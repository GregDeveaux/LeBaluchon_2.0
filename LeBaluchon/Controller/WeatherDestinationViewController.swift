//
//  WeatherDestinationViewController.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 12/10/2022.
//

import UIKit

class WeatherDestinationViewController: UIViewController {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var degresLabel: UILabel!
    @IBOutlet var unitTempLabels: [UILabel]!
    @IBOutlet weak var hightTempDayLabel: UILabel!
    @IBOutlet weak var lowTempDayLabel: UILabel!
    @IBOutlet weak var descriptionSkyLabel: UILabel!
    @IBOutlet weak var descriptionSkyImageView: UIImageView!

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var characterImage: UIImageView!

    @IBOutlet weak var button: UIButton!

    let userDefaults = UserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func tappedButton(_ sender: Any) {

        guard let destinationCity = userDefaults.string(forKey: "destinationCityName") else { return }

        API.QueryService.shared.getData(endpoint: .weather(city: destinationCity, units: "metric"), type: API.Weather.DataForCity.self) { results in
            switch results {
            case .failure(let error):
                print(error.localizedDescription)

            case .success(let results):
                let weatherForCity = results
                self.cityLabel.text = String(weatherForCity.name)

                self.degresLabel.text = String(Int(weatherForCity.main.temp))
                self.hightTempDayLabel.text = String(Int(weatherForCity.main.tempMax))
                self.lowTempDayLabel.text = String(Int(weatherForCity.main.tempMin))

                self.dayLabel.text = String(weatherForCity.date)

                if let description = weatherForCity.weather.first?.description {
                    self.descriptionSkyLabel.text = description
                }

                self.giveTheDate(weatherForCity.date)
            }
        }
    }

    func giveTheDate(_ date: Int) {
        let todayDate = Date(timeIntervalSinceReferenceDate: TimeInterval(date))

        let formatterHour = DateFormatter()
        formatterHour.timeStyle = .short
        print("✅ date of destination: \(formatterHour.string(from: todayDate))")

        let formatterDay = DateFormatter()
        formatterDay.dateFormat = "EEEE, d"
        print("✅ hour of destination:  \(formatterDay.string(from: todayDate))")

        dayLabel.text = formatterDay.string(from: todayDate)
        hourLabel.text = formatterHour.string(from: todayDate)
    }
}
