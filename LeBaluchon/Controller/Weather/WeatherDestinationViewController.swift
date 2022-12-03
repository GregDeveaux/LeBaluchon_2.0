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


        // -------------------------------------------------------
        // MARK: - viewDidAppear
        // -------------------------------------------------------

    override func viewDidAppear(_ animated: Bool) {
        giveMeTheWeather()
    }



        // -------------------------------------------------------
        // MARK: - use API Weather, recover info
        // -------------------------------------------------------

    func giveMeTheWeather() {
        guard let destinationCity = userDefaults.string(forKey: "destinationCityName") else { return }
        guard let destinationCountry = userDefaults.string(forKey: "destinationCountry") else { return }

//        API.QueryService.shared.getData(endpoint: .weather(city: destinationCity, units: "metric"), type: API.Weather.DataForCity.self) { [self] results in
//            switch results {
//                case .failure(let error):
//                    print(error.localizedDescription)
//
//                case .success(let results):
//                    let weatherForCity = results
//                    cityLabel.text = destinationCity
//                    countryLabel.text = destinationCountry
//
//                    degresLabel.text = String(Int(weatherForCity.main.temp))
//                    hightTempDayLabel.text = String(Int(weatherForCity.main.tempMax))
//                    lowTempDayLabel.text = String(Int(weatherForCity.main.tempMin))
//
//                    dayLabel.text = self.giveMeTheDate(weatherForCity.date).dayLabel
//                    hourLabel.text = self.giveMeTheDate(weatherForCity.date).hourLabel
//
//                    guard let description = weatherForCity.weather.first?.description,
//                          let weatherDescription = WeatherDescription(rawValue: description)
//                    else { return }
//                    descriptionSkyLabel.text = weatherDescription.rawValue
//
//                        // Recover the images by the description weather
//                    let weatherImages = ImagesWeather.weatherImage(for: weatherDescription,
//                                                                 sunrise: weatherForCity.sys.sunrise,
//                                                                 sunset: weatherForCity.sys.sunset,
//                                                                 hourOfCountry: weatherForCity.date)
//                    print("""
//                          ✅ Description = \(description)
//                          ☀️ \(String(describing: weatherForCity.sys.sunrise))
//                          🌜 \(String(describing: weatherForCity.sys.sunset))
//                          ⌚️ \(String(describing: weatherForCity.date))
//                          🖼 \(weatherImages)
//                    """)
//
//                    giveMeTheWeatherImages(weatherImages: weatherImages,
//                                           background: backgroundImage,
//                                           description: descriptionSkyImageView,
//                                           characterImage: characterImage)
//            }
//        }
    }


        // -------------------------------------------------------
        // MARK: - modify images of ViewController
        // -------------------------------------------------------

    private func giveMeTheWeatherImages(weatherImages: [String], background: UIImageView, description: UIImageView, characterImage: UIImageView) {
        background.image = UIImage(named: weatherImages[0])
        description.image = UIImage(systemName: weatherImages[1])
        if weatherImages[1] == "sun.max.fill" {
            description.tintColor = .yellow
        }
        self.characterImage.image = UIImage(named: weatherImages[2])
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
}
