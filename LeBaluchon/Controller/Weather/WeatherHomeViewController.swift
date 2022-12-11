//
//  ViewController.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 10/10/2022.
//

import UIKit

class WeatherHomeViewController: UIViewController {

        // -------------------------------------------------------
        // MARK: Properties
        // -------------------------------------------------------

    @IBOutlet var temperatureUnitLabel: [UILabel]!

        // -------- User weather ---------
    @IBOutlet weak var userCityLabel: UILabel!
    @IBOutlet weak var userCountryLabel: UILabel!

    @IBOutlet weak var userTemperatureLabel: UILabel!
    @IBOutlet weak var userHightTemperatureLabel: UILabel!
    @IBOutlet weak var userLowTemperatureLabel: UILabel!

    @IBOutlet weak var userIconeImageView: UIImageView!
    @IBOutlet weak var userDescriptionLabel: UILabel!

    @IBOutlet weak var userDateLabel: UILabel!
    @IBOutlet weak var userHourLabel: UILabel!

    @IBOutlet weak var userBackgroundImageView: UIImageView!

        // -------- Destination weather --------
    @IBOutlet weak var destinationCityLabel: UILabel!
    @IBOutlet weak var destinationCountryLabel: UILabel!

    @IBOutlet weak var destinationTemperatureLabel: UILabel!
    @IBOutlet weak var destinationHightTemperatureLabel: UILabel!
    @IBOutlet weak var destinationLowTemperatureLabel: UILabel!

    @IBOutlet weak var destinationIconeImageView: UIImageView!
    @IBOutlet weak var destinationDescriptionLabel: UILabel!

    @IBOutlet weak var destinationDateLabel: UILabel!
    @IBOutlet weak var destinationHourLabel: UILabel!

    @IBOutlet weak var destinationBackgroundImageView: UIImageView!

        // -------- Others --------
    let todayDate = Date.now
    let userDefaults = UserDefaults.standard

    let unit = "metric"

    lazy var backgroundUnderTabBar: UIView = {
        let backgroundUnderTabBar = UIView()
        backgroundUnderTabBar.frame = CGRect(x: 0, y: 800, width: UIScreen.main.bounds.width, height: 76)
        backgroundUnderTabBar.backgroundColor = .greenAurora
        return backgroundUnderTabBar
    }()

    lazy var lineTabBar: UIView = {
        let lineTabBar = UIView()
        lineTabBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1)
        lineTabBar.backgroundColor = .white

        lineTabBar.translatesAutoresizingMaskIntoConstraints = false
        lineTabBar.bottomAnchor.constraint(equalTo: lineTabBar.safeAreaLayoutGuide.bottomAnchor).isActive = true
        lineTabBar.centerXAnchor.constraint(equalTo: lineTabBar.safeAreaLayoutGuide.centerXAnchor).isActive = true
        return lineTabBar
    }()


        // -------------------------------------------------------
        // MARK: view life
        // -------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        giveMeTheWeathers()
    }

        // -------------------------------------------------------
        // MARK: - use API Weather, recover info
        // -------------------------------------------------------

    func giveMeTheWeathers() {
        guard let userCityName = userDefaults.string(forKey: "userCityName") else { return }
        guard let userCountry = userDefaults.string(forKey: "userCountry") else { return }

        API.QueryService.shared.getData(endpoint: .weather(city: userCityName, units: "metric"), type: API.Weather.DataForCity.self) { results in
            switch results {
                case .failure(let error):
                    print(error.localizedDescription)

                case .success(let results):
                    let weatherForCity = results
                    self.userCityLabel.text = userCityName
                    self.userCountryLabel.text = userCountry

                    self.userTemperatureLabel.text = String(Int(weatherForCity.main.temp))
                    self.userHightTemperatureLabel.text = String(Int(weatherForCity.main.tempMax))
                    self.userLowTemperatureLabel.text = String(Int(weatherForCity.main.tempMin))

                    self.userDateLabel.text = self.giveMeTheDate(weatherForCity.date, timeZoneCity: weatherForCity.timezone).dayLabel
                    self.userHourLabel.text = self.giveMeTheDate(weatherForCity.date, timeZoneCity: weatherForCity.timezone).hourLabel

                    guard let description = weatherForCity.weather.first?.description,
                          let weatherDescription = WeatherDescription(rawValue: description)
                    else { return }
                    self.userDescriptionLabel.text = weatherDescription.rawValue

                        // Recover the images by the description weather and by the hour
                    let weatherImages = ImagesWeather.weatherImage(for: weatherDescription,
                                                                   sunrise: weatherForCity.sys.sunrise,
                                                                   sunset: weatherForCity.sys.sunset,
                                                                   hourOfCountry: weatherForCity.date)
                    print("""
                              1️⃣ ✅ Description = \(description)
                              1️⃣ ☀️ \(String(describing: weatherForCity.sys.sunrise))
                              1️⃣ 🌜 \(String(describing: weatherForCity.sys.sunset))
                              1️⃣ ⌚️ \(String(describing: weatherForCity.date))
                              1️⃣ 🖼 \(weatherImages)
                        """)

                    self.giveMeTheWeatherImages(weatherImages: weatherImages,
                                                background: self.userBackgroundImageView,
                                                description: self.userIconeImageView)

                        //  call the destination to send the data
                    self.giveMeTheDestinationWeather()
            }
        }
    }


    func giveMeTheDestinationWeather() {

        guard let destinationCity = userDefaults.string(forKey: "destinationCityName") else { return }
        guard let destinationCountry = userDefaults.string(forKey: "destinationCountry") else { return }

        API.QueryService.shared.getData(endpoint: .weather(city: destinationCity, units: unit), type: API.Weather.DataForCity.self) { results in
            switch results {
                case .failure(let error):
                    self.presentAlert(message: "Sorry, the destination weather failed")
                    print(error.localizedDescription)

                case .success(let results):
                    let weatherForCity = results

                    self.destinationCityLabel.text = destinationCity
                    self.destinationCountryLabel.text = destinationCountry
                    self.destinationTemperatureLabel.text = String(Int(weatherForCity.main.temp))
                    self.destinationHightTemperatureLabel.text = String(Int(weatherForCity.main.tempMax))
                    self.destinationLowTemperatureLabel.text = String(Int(weatherForCity.main.tempMin))


                    self.destinationDateLabel.text = self.giveMeTheDate(weatherForCity.date, timeZoneCity: weatherForCity.timezone).dayLabel
                    self.destinationHourLabel.text = self.giveMeTheDate(weatherForCity.date, timeZoneCity: weatherForCity.timezone).hourLabel

                    guard let description = weatherForCity.weather.first?.description,
                          let weatherDescription = WeatherDescription(rawValue: description)
                    else { return }
                    self.destinationDescriptionLabel.text = weatherDescription.rawValue

                        // Recover the images by the description weather
                    let weatherImages = ImagesWeather.weatherImage(for: weatherDescription,
                                                                   sunrise: weatherForCity.sys.sunrise,
                                                                   sunset: weatherForCity.sys.sunset,
                                                                   hourOfCountry: weatherForCity.date)
                    print("""
                                  2️⃣ ✅ Description = \(description)
                                  2️⃣ ☀️ \(String(describing: weatherForCity.sys.sunrise))
                                  2️⃣ 🌜 \(String(describing: weatherForCity.sys.sunset))
                                  2️⃣ ⌚️ \(String(describing: weatherForCity.date))
                                  2️⃣ 🖼 \(weatherImages)
                            """)

                    self.giveMeTheWeatherImages(weatherImages: weatherImages,
                                                background: self.destinationBackgroundImageView,
                                                description: self.destinationIconeImageView)
            }
        }
    }

        // -------------------------------------------------------
        // MARK: - modify images of ViewController
        // -------------------------------------------------------

    private func giveMeTheWeatherImages(weatherImages: [String], background: UIImageView, description: UIImageView) {
        background.image = UIImage(named: weatherImages[0])
        description.image = UIImage(systemName: weatherImages[1])
        if weatherImages[1] == "sun.max.fill" {
            description.tintColor = .yellow
        }
    }


        // -------------------------------------------------------
        // MARK: - format date
        // -------------------------------------------------------

    func giveMeTheDate(_ date: Int, timeZoneCity: Int) -> (dayLabel: String?, hourLabel: String?) {
        let todayDate = Date(timeIntervalSinceReferenceDate: TimeInterval(date))

        let formatterHour = DateFormatter()
        formatterHour.timeZone = .init(secondsFromGMT: timeZoneCity)
        formatterHour.timeStyle = .short
        print("✅ date of destination: \(formatterHour.string(from: todayDate))")

        let formatterDay = DateFormatter()
        formatterHour.timeZone = .init(secondsFromGMT: timeZoneCity)
        formatterDay.dateFormat = "EEEE, d"
        print("✅ hour of destination:  \(formatterDay.string(from: todayDate))")

        let dayLabel = formatterDay.string(from: todayDate)
        let hourLabel = formatterHour.string(from: todayDate)

        return (dayLabel, hourLabel)
    }
}
