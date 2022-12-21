//
//  MapViewController.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 05/11/2022.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

        // -------------------------------------------------------
        // MARK: - properties
        // -------------------------------------------------------

    var user = User()
    var destination = Destination()

    var pinUser: PinMap!
    var pinDestination: PinMap!

    let locationManager = CLLocationManager()
    var currentLocationUser: CLLocation?
    var route: MKRoute?
    var linePolyline = MKPolyline()
    

        // -------------------------------------------------------
        // MARK: - outlets
        // -------------------------------------------------------

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var modifyDestinationButton: UIButton!


        // -------------------------------------------------------
        // MARK: - viewDidLoad
        // -------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLocationManager()
        print("✅ MAP: destination latitude \(destination.latitude) et longitude \(destination.longitude)")
        print("✅ MAP: user latitude \(user.latitude) et longitude \(user.longitude)")
        setMapView()

        createRoute(to: CLLocationCoordinate2D(latitude: destination.latitude, longitude: destination.longitude))
        print("✅ MAP: route \(createRoute(to: CLLocationCoordinate2D(latitude: destination.latitude, longitude: destination.longitude)))")
    }


        // -------------------------------------------------------
        // MARK: - button new destination
        // -------------------------------------------------------

    @IBAction func tappedModifyDestination(_ sender: UIButton) {
            // return to login view
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(identifier: "LoginViewController")
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.window?.rootViewController = loginViewController
    }


        // -------------------------------------------------------
        // MARK: - setup user
        // -------------------------------------------------------

    func setupUser(latitude: Double, longitude: Double) {
        API.LocalisationCity.foundCountryByCoordinates(latitude: String(latitude), longitude: String(longitude)) { result in
            guard let cityInfo = result else { return }
            self.user.cityName = cityInfo.name
            self.user.latitude = cityInfo.latitude
            self.user.longitude = cityInfo.longitude
            self.user.countryName = cityInfo.country
            self.user.countryCode = cityInfo.countryCode
            self.userNameLabel.text = self.user.welcomeMessage
            print("✅ MAP CELLPHONE USER: user City Name \(self.user.cityName ), in \(self.user.countryName ) with country code : \(self.user.countryCode )")
            print("✅ MAP CELLPHONE USER: coordinates receive of \(self.user.name) are lat:\(self.user.latitude ) et long:\(self.user.longitude )")
        }
    }
}

extension MapViewController: MKMapViewDelegate {

        // -------------------------------------------------------
        // MARK: - map with pins
        // -------------------------------------------------------

    private func setMapView() {
        mapView.delegate = self
            // the map will remain in its light version
        mapView.overrideUserInterfaceStyle = .light
            // the map follow user
        mapView.showsUserLocation = true
            // delete the user rotation
        mapView.isRotateEnabled = false

            // we indicate the different pin for the start (location user) and the destination
        setupPinMap()
        guard let pinDestination = pinDestination else { return }
        guard let pinUser = pinUser else { return }
        mapView.addAnnotations([pinUser, pinDestination])
    }

    private func setupPinMap() {
            //destination Pin
        if destination.latitude != 0 && destination.longitude != 0  {
            pinDestination = PinMap(title: "you want to go to \(destination.cityName)",
                                    coordinate: CLLocationCoordinate2D(latitude: (destination.latitude),
                                                                       longitude: (destination.longitude)),
                                    info: "destination")
            print("✅ MAP: pin destination: \(pinDestination.title ?? "unknow")")
        }
            // user Pin
        if let userCoordinates = currentLocationUser?.coordinate {
            pinUser = PinMap(title: "Hello \(user.name)! it's you!",
                             coordinate: CLLocationCoordinate2D(latitude: (userCoordinates.latitude),
                                                                longitude: (userCoordinates.longitude)),
                             info: "start")

            print("✅ MAP: pin user: \(pinUser.title ?? "unknow")")
            print("📍 MAP: user latitude \(currentLocationUser?.coordinate.latitude ?? 0) et longitude \(currentLocationUser?.coordinate.latitude ?? 0)")
        }
        else if user.latitude != 0 && user.longitude != 0 {
            pinUser = PinMap(title: "Hello \(user.name)! it's you!",
                             coordinate: CLLocationCoordinate2D(latitude: (user.latitude),
                                                                longitude: (user.longitude)),
                             info: "start")
            print("✅ MAP: pin user: \(pinUser.title ?? "unknow")")
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is PinMap else { return nil }

            // custom pinUser
        let identifier = "customPin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: pinDestination, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }

            // personnalize the icone
        switch annotation.title {
            case "you want to go to \(destination.cityName)":
                annotationView?.image = UIImage(named: "pinDestination")
            case "Hello \(user.name)! it's you!":
                annotationView?.image = UIImage(named: "pinDepart")
            default:
                break
        }
        annotationView?.frame.size = CGSize(width: 150, height: 90)

        return annotationView
    }
}
