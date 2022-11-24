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
        return lineTabBar
    }()


        // -------------------------------------------------------
        // MARK: viewDidLoad
        // -------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWeatherDestinationViewController()

        giveTheDate()
        setupGestureRecognizer(to: weatherDestinationViewController.view)
        view.addSubview(backgroundUnderTabBar)
        backgroundImage.addSubview(lineTabBar)

//        backgroundUnderTabBar.translatesAutoresizingMaskIntoConstraints = false
//        backgroundUnderTabBar.bottomAnchor.constraint(equalTo: view.topAnchor).isActive = true
//
//        lineTabBar.translatesAutoresizingMaskIntoConstraints = false
//        lineTabBar.leftAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: 0).isActive = true
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
