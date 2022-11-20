//
//  ViewController.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 10/10/2022.
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

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var characterImage: UIImageView!

    var weatherDestinationViewController: UIViewController!

    let todayDate = Date.now

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWeatherDestinationViewController()

        giveTheDate()

        swipeWeatherDestination()
    }

    private func swipeWeatherDestination() {
        swipeDirection(.up, action: #selector(swipeAction(direction:)))
        swipeDirection(.down, action: #selector(swipeAction(direction:)))
    }

    @objc private func swipeAction(direction: UISwipeGestureRecognizer.Direction) {
        switch direction {
            case .up:
                UIView.animate(withDuration: 0.20) {
                    self.weatherDestinationViewController.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
//                    self.weatherDestinationViewController.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
                }
            case .down:
                UIView.animate(withDuration: 0.20) {
                    self.weatherDestinationViewController.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
                }
            default:
                break
        }
    }

        // add function to multiply swipes action and direction
    private func swipeDirection(_ direction: UISwipeGestureRecognizer.Direction, action: Selector?) {
        let swipe = UISwipeGestureRecognizer(target: self, action: action)
        swipe.direction = direction
        self.view.addGestureRecognizer(swipe)
    }

    func setupWeatherDestinationViewController() {
        weatherDestinationViewController = storyboard?.instantiateViewController(withIdentifier: "WeatherDestinationViewController")
        addChild(weatherDestinationViewController)
        view.addSubview(weatherDestinationViewController.view)
        weatherDestinationViewController.didMove(toParent: self)
        setChildViewController(to: weatherDestinationViewController)
    }

    func setChildViewController(to viewController: UIViewController) {
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        viewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        viewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        viewController.view.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor,
                                                    constant: 200).isActive = true
    }


    @IBAction func tappedForWeather(_ sender: Any) {
        API.QueryService.shared.getWeather(endpoint: .weather(city: "Lille", units: "metric"),
                                           method: .GET) { success, weatherForCity in
            guard let weatherForCity = weatherForCity, success == true else {
                print(API.Error.generic(reason: "not shown data"))
                return
            }
            self.cityLabel.text = String(weatherForCity.name)

            self.degresLabel.text = String(Int(weatherForCity.main.temp))
            self.hightTempDayLabel.text = String(Int(weatherForCity.main.tempMax))
            self.lowTempDayLabel.text = String(Int(weatherForCity.main.tempMin))

            self.dayLabel.text = String(weatherForCity.date)

            if let description = weatherForCity.weather.first?.description {
                self.descriptionSkyLabel.text = description
            }
        }
    }


    private func giveTheDate() {
        let formatterHour = DateFormatter()
        formatterHour.timeStyle = .short
        print("✅ date of home \(formatterHour.string(from: todayDate))")

        let formatterDay = DateFormatter()
        formatterDay.dateFormat = "EEEE, d"
        print("✅ hour of home \(formatterDay.string(from: todayDate))")

        dayLabel.text = formatterDay.string(from: todayDate)
        hourLabel.text = formatterHour.string(from: todayDate)
    }

}
