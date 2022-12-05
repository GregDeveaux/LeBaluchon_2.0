//
//  ViewController.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 10/10/2022.
//

import UIKit

//extension WeatherHomeViewController: WeatherDestinationViewControllerDelegate {
//    func rescueTheData(_ vc: WeatherDestinationViewController) {
//        weatherDestinationViewController.cityDestinationLabel.text = "Rien"
//        print("🍀 \(String(describing: weatherDestinationViewController.cityDestinationLabel.text))")
//    }
//}

class WeatherHomeViewController: UIViewController {

        // -------------------------------------------------------
        // MARK: Properties
        // -------------------------------------------------------

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var degresLabel: UILabel!
    @IBOutlet weak var unitTempLabels: UILabel!
    @IBOutlet weak var hightTempDayLabel: UILabel!
    @IBOutlet weak var lowTempDayLabel: UILabel!
    @IBOutlet weak var descriptionSkyLabel: UILabel!
    @IBOutlet weak var descriptionSkyImageView: UIImageView!

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var characterImage: UIImageView!

    private weak var weatherDestinationSheet: UIViewController!
    let weatherDestinationViewController = WeatherDestinationViewController()

    let todayDate = Date.now
    let userDefaults = UserDefaults.standard

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
        setupWeatherDestinationViewController()

        setupGestureRecognizer(to: weatherDestinationSheet.view)
        view.addSubview(backgroundUnderTabBar)
        backgroundUnderTabBar.addSubview(lineTabBar)

//        backgroundUnderTabBar.translatesAutoresizingMaskIntoConstraints = false
//        backgroundUnderTabBar.bottomAnchor.constraint(equalTo: view.topAnchor).isActive = true
//
//        lineTabBar.translatesAutoresizingMaskIntoConstraints = false
//        lineTabBar.leftAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: 0).isActive = true

        giveMeTheWeather()
    }


        // -------------------------------------------------------
        // MARK: - use API Weather, recover info
        // -------------------------------------------------------

    func giveMeTheWeather() {
        guard let userCityName = userDefaults.string(forKey: "userCityName") else { return }
        guard let userCountry = userDefaults.string(forKey: "userCountry") else { return }

        API.QueryService.shared.getData(endpoint: .weather(city: userCityName, units: "metric"), type: API.Weather.DataForCity.self) { [self] results in
            switch results {
                case .failure(let error):
                    print(error.localizedDescription)

                case .success(let results):
                    let weatherForCity = results
                    cityLabel.text = userCityName
                    countryLabel.text = userCountry

                    degresLabel.text = String(Int(weatherForCity.main.temp))
                    hightTempDayLabel.text = String(Int(weatherForCity.main.tempMax))
                    lowTempDayLabel.text = String(Int(weatherForCity.main.tempMin))

                    dayLabel.text = self.giveMeTheDate(weatherForCity.date).dayLabel
                    hourLabel.text = self.giveMeTheDate(weatherForCity.date).hourLabel

                    guard let description = weatherForCity.weather.first?.description,
                          let weatherDescription = WeatherDescription(rawValue: description)
                    else { return }
                    descriptionSkyLabel.text = weatherDescription.rawValue

                        // Recover the images by the description weather and by the hour
                    let weatherImages = ImagesWeather.weatherImage(for: weatherDescription,
                                                                   sunrise: weatherForCity.sys.sunrise,
                                                                   sunset: weatherForCity.sys.sunset,
                                                                   hourOfCountry: weatherForCity.date)
                    print("""
                              ✅ Description = \(description)
                              ☀️ \(String(describing: weatherForCity.sys.sunrise))
                              🌜 \(String(describing: weatherForCity.sys.sunset))
                              ⌚️ \(String(describing: weatherForCity.date))
                              🖼 \(weatherImages)
                        """)

                    giveMeTheWeatherImages(weatherImages: weatherImages,
                                           background: backgroundImage,
                                           description: descriptionSkyImageView,
                                           characterImage: characterImage)

                        // call the destination to send the data
                    weatherDestinationViewController.giveMeTheWeather()
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
        // MARK: setups for sheet viewController
        // -------------------------------------------------------

    func setupWeatherDestinationViewController() {
        weatherDestinationSheet = storyboard?.instantiateViewController(withIdentifier: "WeatherDestinationViewController")
        addChild(weatherDestinationSheet)
        view.addSubview(weatherDestinationSheet.view)
        setInitChildViewController(to: weatherDestinationSheet)
        weatherDestinationSheet.didMove(toParent: self)
    }

    func setInitChildViewController(to viewController: UIViewController) {
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        viewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        viewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        viewController.view.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor,
                                                    constant: 200).isActive = true

        viewController.view.isUserInteractionEnabled = true
    }

    func setupGestureRecognizer(to view: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handleGesture(_:)))
        view.addGestureRecognizer(panGesture)
    }

    @objc func handleGesture(_ panGesture: UIPanGestureRecognizer) {
        if panGesture.state == .began {
            print("👆 begin to began!")
        }
        if panGesture.state == .changed {
            let translation = panGesture.translation(in: self.view)
            weatherDestinationSheet.view.transform = CGAffineTransform(translationX: 0, y: translation.y)
            print("👆 begin to change!")
        }
        else if panGesture.state == .ended {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn) {
                self.weatherDestinationSheet.view.transform = .identity
            }
            print("👆 begin to end!")
        }
    }


        // -------------------------------------------------------
        // MARK: - format date
        // -------------------------------------------------------

    func giveMeTheDate(_ date: Int) -> (dayLabel: String?, hourLabel: String?) {
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
