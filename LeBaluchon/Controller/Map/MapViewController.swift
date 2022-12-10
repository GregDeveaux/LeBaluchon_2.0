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

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var modifyDestinationButton: UIButton!

    let userDefaults = UserDefaults.standard
    let userName = UserDefaults.standard.string(forKey: "userName") ?? "unknow"
    let destinationCityName = UserDefaults.standard.string(forKey: "destinationCityName") ?? "unknow"
    let destinationCityLatitude = UserDefaults.standard.double(forKey: "destinationCityLatitude")
    let destinationCityLongitude = UserDefaults.standard.double(forKey: "destinationCityLongitude")

    var user: User!
    var destinationCity: DestinationCity!

    var pinUser: PinMap!
    var pinDestination: PinMap!

    let locationManager = CLLocationManager()
    var currentLocationUser: CLLocation?
    var route: MKRoute?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLocationManager()
    }

    override func viewWillAppear(_ animated: Bool) {
        setMapView()
        print("📍🏖 latitude \(destinationCityLatitude) et longitude \(destinationCityLongitude)")

        createRoute(to: CLLocationCoordinate2D(latitude: destinationCityLatitude, longitude: destinationCityLongitude))
        print("✅ route \(createRoute(to: CLLocationCoordinate2D(latitude: destinationCityLatitude, longitude: destinationCityLongitude)))")
    }

    func setupUser(latitude: Double, longitude: Double) {
        API.City.foundCountryByCoordinates(latitude: String(latitude), longitude: String(longitude)) { [self] cityInfo in
            user = User(name: userName,
                        coordinates: CoordinatesInfo(latitude: latitude, longitude: longitude),
                        cityName: cityInfo.name,
                        country: cityInfo.country,
                        countryCode: cityInfo.countryCode)
//            userDefaults.set(latitude, forKey: "userLatitude")
//            userDefaults.set(longitude, forKey: "userLongitude")
//            userDefaults.set(cityInfo.name, forKey: "userCityName")
//            userDefaults.set(cityInfo.country, forKey: "userCountry")
//            userDefaults.set(cityInfo.countryCode, forKey: "userCountryCode")
            userNameLabel.text = user.welcomeMessage
            print("✅📲 user City Name \(cityInfo.name), in \(cityInfo.country) with country code : \(cityInfo.countryCode)")
            print("✅ coordinates receive of \(userName) are lat:\(latitude) et long:\(longitude))")
        }
    }
    
    @IBAction func tappedModifyDestination(_ sender: UIButton) {
            // return to login view
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(identifier: "LoginViewController")
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.window?.rootViewController = loginViewController
    }
}

extension MapViewController: MKMapViewDelegate {

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
//        mapView.addAnnotations([pinUser, pinDestination])
        mapView.addAnnotation(pinDestination)
    }

    private func setupPinMap() {

        if destinationCityLatitude != 0 && destinationCityLongitude != 0  {
            pinDestination = PinMap(title: "you want to go to \(destinationCityName)",
                                    coordinate: CLLocationCoordinate2D(latitude: (destinationCityLatitude),
                                                                       longitude: (destinationCityLongitude)),
                                    info: "destination")
            print("✅ pin destination: \(pinDestination.title ?? "unknow")")
        }

        if let userCoordinates = currentLocationUser?.coordinate {
            pinUser = PinMap(title: "Hello \(userName)! it's you!",
                             coordinate: CLLocationCoordinate2D(latitude: (userCoordinates.latitude),
                                                                longitude: (userCoordinates.longitude)),
                             info: "start")

            print("✅ pin user: \(pinUser?.title ?? "unknow")")
            print("📍 latitude \(currentLocationUser?.coordinate.latitude ?? 0) et longitude \(currentLocationUser?.coordinate.latitude ?? 0)")
        }
    }

    func createRoute(to destinationCityCoordinates: CLLocationCoordinate2D) {
        guard let userCoordinates = locationManager.location?.coordinate else { return }

        let userPlacemark = MKPlacemark(coordinate: userCoordinates)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCityCoordinates)

        let userItem = MKMapItem(placemark: userPlacemark)
        let destinationItem = MKMapItem(placemark: destinationPlacemark)

        let destinationRequest = MKDirections.Request()
        destinationRequest.source = userItem
        destinationRequest.destination = destinationItem
        destinationRequest.transportType = .any

        let directions = MKDirections(request: destinationRequest)
        directions.calculate { response, error in
            guard let response = response else {
                print("  error of creation of route")
                return }

            guard let route = response.routes.first else { return }
            self.mapView.addOverlay(route.polyline)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        }
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = .pinkGranada
        renderer.lineWidth = 10
        return renderer
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

        switch annotation.title {
            case "you want to go to \(destinationCityName)":
                annotationView?.image = UIImage(named: "pinDestination")
            case user?.welcomeMessage:
                annotationView?.image = UIImage(named: "pinUser")
            default:
                break
        }
        annotationView?.frame.size = CGSize(width: 150, height: 90)

        return annotationView
    }
}

    // -------------------------------------------------------
    //MARK: - found the user's coordinates
    // -------------------------------------------------------

extension MapViewController: CLLocationManagerDelegate {

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

        // geolocalization of user
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.first else { return }
        currentLocationUser = location

            // Save the coordinates of user
        setupUser(latitude: currentLocationUser?.coordinate.latitude ?? 0, longitude: currentLocationUser?.coordinate.longitude ?? 0)

            // create aline a line between the user and the destination
        let startPolyline = location.coordinate
        let destinationPolyline = CLLocationCoordinate2D(latitude: destinationCityLatitude, longitude: destinationCityLongitude)
        let coordinatesPolyline = [startPolyline, destinationPolyline]
        let polyline = MKPolyline(coordinates: coordinatesPolyline, count: coordinatesPolyline.count)

        mapView.addOverlay(polyline)

        let center = CLLocationCoordinate2D(latitude: currentLocationUser?.coordinate.latitude ?? 0,
                                            longitude: currentLocationUser?.coordinate.longitude ?? 0)
        let span = MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)

    }
}
