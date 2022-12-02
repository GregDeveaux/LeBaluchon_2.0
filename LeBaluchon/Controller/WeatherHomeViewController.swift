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

    private weak var weatherDestinationViewController: UIViewController!

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

        setupGestureRecognizer(to: weatherDestinationViewController.view)
        view.addSubview(backgroundUnderTabBar)
        backgroundUnderTabBar.addSubview(lineTabBar)

//        backgroundUnderTabBar.translatesAutoresizingMaskIntoConstraints = false
//        backgroundUnderTabBar.bottomAnchor.constraint(equalTo: view.topAnchor).isActive = true
//
//        lineTabBar.translatesAutoresizingMaskIntoConstraints = false
//        lineTabBar.leftAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: 0).isActive = true
    }

    override func viewDidAppear(_ animated: Bool) {
        guard let userCityName = self.userDefaults.string(forKey: "userCityName") else { return }
        guard let userCountry = userDefaults.string(forKey: "userCountry") else { return }

            API.QueryService.shared.getData(endpoint: .weather(city: userCityName, units: "metric"), type: API.Weather.DataForCity.self) { results in
                switch results {
                case .failure(let error):
                    print(error.localizedDescription)

                case .success(let results):
                    let weatherForCity = results
                    self.cityLabel.text = userCityName
                    self.countryLabel.text = userCountry

                    self.degresLabel.text = String(Int(weatherForCity.main.temp))
                    self.hightTempDayLabel.text = String(Int(weatherForCity.main.tempMax))
                    self.lowTempDayLabel.text = String(Int(weatherForCity.main.tempMin))

                    self.dayLabel.text = self.giveTheDate(weatherForCity.date).dayLabel
                    self.hourLabel.text = self.giveTheDate(weatherForCity.date).hourLabel

                    guard let description = weatherForCity.weather.first?.description else { return }
                    self.descriptionSkyLabel.text = description

                    let imageForViewController = UIImageView.weatherImage(for: description,
                                                                          sunrise: weatherForCity.sys.sunrise,
                                                                          sunset: weatherForCity.sys.sunset,
                                                                          hourOfContry: weatherForCity.date)
                    print(" description = \(description)")
                    print(" ☀️H \(String(describing: weatherForCity.sys.sunrise))")
                    print(" 🌜H \(String(describing: weatherForCity.sys.sunset))")
                    print(" ⌚️H \(String(describing: weatherForCity.date))")
                    print(" 🖼H \(imageForViewController)")
                }
            }
    }

        // -------------------------------------------------------
        // MARK: setups
        // -------------------------------------------------------

    func setupWeatherDestinationViewController() {
        weatherDestinationViewController = storyboard?.instantiateViewController(withIdentifier: "WeatherDestinationViewController")
        addChild(weatherDestinationViewController)
        view.addSubview(weatherDestinationViewController.view)
        setInitChildViewController(to: weatherDestinationViewController)
        weatherDestinationViewController.didMove(toParent: self)
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
            weatherDestinationViewController.view.transform = CGAffineTransform(translationX: 0, y: translation.y)
            print("👆 begin to change!")
        }
        else if panGesture.state == .ended {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn) {
                self.weatherDestinationViewController.view.transform = .identity
            }
            print("👆 begin to end!")
        }
    }

    @IBAction func tappedForWeather(_ sender: Any) {

//        guard let userCityName = self.userDefaults.string(forKey: "userCityName") else { return }
//        guard let userCountry = userDefaults.string(forKey: "userCountry") else { return }
//
//            API.QueryService.shared.getData(endpoint: .weather(city: userCityName, units: "metric"), type: API.Weather.DataForCity.self) { results in
//                switch results {
//                case .failure(let error):
//                    print(error.localizedDescription)
//
//                case .success(let results):
//                    let weatherForCity = results
//                    self.cityLabel.text = userCityName
//                    self.countryLabel.text = userCountry
//
//                    self.degresLabel.text = String(Int(weatherForCity.main.temp))
//                    self.hightTempDayLabel.text = String(Int(weatherForCity.main.tempMax))
//                    self.lowTempDayLabel.text = String(Int(weatherForCity.main.tempMin))
//
//                    self.dayLabel.text = self.giveTheDate(weatherForCity.date).dayLabel
//                    self.hourLabel.text = self.giveTheDate(weatherForCity.date).hourLabel
//
//                    guard let description = weatherForCity.weather.first?.description else { return }
//                    self.descriptionSkyLabel.text = description
//
//                    let imageForViewController = UIImageView.weatherImage(for: description,
//                                                                          sunrise: weatherForCity.sys.sunrise,
//                                                                          sunset: weatherForCity.sys.sunset,
//                                                                          hourOfContry: weatherForCity.date)
//                    print(" description = \(description)")
//                    print(" ☀️H \(String(describing: weatherForCity.sys.sunrise))")
//                    print(" 🌜H \(String(describing: weatherForCity.sys.sunset))")
//                    print(" ⌚️H \(String(describing: weatherForCity.date))")
//                    print(" 🖼H \(imageForViewController)")
//                }
//            }
        }

    func giveTheDate(_ date: Int) -> (dayLabel: String?, hourLabel: String?) {
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
