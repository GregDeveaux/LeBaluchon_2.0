//
//  WeatherDestinationViewController.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 12/10/2022.
//

import UIKit

//protocol WeatherDestinationViewControllerDelegate: AnyObject {
//    func rescueTheData(_ vc: WeatherDestinationViewController)
//}

class WeatherDestinationViewController: UIViewController {

//    weak var delegate: WeatherDestinationViewControllerDelegate?
//
//    func rescueData() {
//        delegate?.rescueTheData(self)
//    }

        // -------------------------------------------------------
        // MARK: - properties
        // -------------------------------------------------------

    @IBOutlet weak var countryNameDestinationLabel: UILabel!
    @IBOutlet weak var cityNameDestinationLabel: UILabel!
    @IBOutlet weak var temperatureOfDestinationLabel: UILabel!
    @IBOutlet var unitTempLabels: [UILabel]!
    @IBOutlet weak var hightTempDayLabel: UILabel!
    @IBOutlet weak var lowTempDayLabel: UILabel!
    @IBOutlet weak var descriptionSkyLabel: UILabel!
    @IBOutlet weak var descriptionSkyImageView: UIImageView!

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var characterImage: UIImageView!

    let userDefaults = UserDefaults()

    var destinationCityzzzzz = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }


        // -------------------------------------------------------
        // MARK: - viewDidAppear
        // -------------------------------------------------------

    override func viewDidAppear(_ animated: Bool) {

    }


        // -------------------------------------------------------
        // MARK: - use API Weather, recover info
        // -------------------------------------------------------

    func giveMeTheWeather() {
        guard let destinationCity = userDefaults.string(forKey: "destinationCityName") else { return }
        guard let destinationCountry = userDefaults.string(forKey: "destinationCountry") else { return }

        API.QueryService.shared.getData(endpoint: .weather(city: destinationCity, units: "metric"), type: API.Weather.DataForCity.self) { [self] results in
            switch results {
                case .failure(let error):
                    print(error.localizedDescription)

                case .success(let results):
                    let weatherForCity = results

                        // >>>>>> si j'enregistre dans une propriété, là ça marche
                    destinationCityzzzzz = destinationCity
                    print(destinationCityzzzzz)

                        // >>>>>> et dès que je veux l'afficher, ça ne marche plus
                        // Thread 1: Fatal error: Unexpectedly found nil while implicitly unwrapping an Optional value
//                    cityNameDestinationLabel.text = destinationCity
//                    countryNameDestinationLabel.text = destinationCountry
//
                    temperatureOfDestinationLabel.text = String(Int(weatherForCity.main.temp))
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
//                                                                   sunrise: weatherForCity.sys.sunrise,
//                                                                   sunset: weatherForCity.sys.sunset,
//                                                                   hourOfCountry: weatherForCity.date)
//                    print("""
//                                  ✅ Description = \(description)
//                                  ☀️ \(String(describing: weatherForCity.sys.sunrise))
//                                  🌜 \(String(describing: weatherForCity.sys.sunset))
//                                  ⌚️ \(String(describing: weatherForCity.date))
//                                  🖼 \(weatherImages)
//                            """)
//
//                    giveMeTheWeatherImages(weatherImages: weatherImages,
//                                           background: backgroundImage,
//                                           description: descriptionSkyImageView,
//                                           characterImage: characterImage)
            }
        }
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
