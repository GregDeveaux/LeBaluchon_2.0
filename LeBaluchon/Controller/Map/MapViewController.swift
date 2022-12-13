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

    var user = User()
    var destination = Destination()

    var pinUser: PinMap!
    var pinDestination: PinMap!

    let locationManager = CLLocationManager()
    var currentLocationUser: CLLocation?
    var route: MKRoute?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()

        setMapView()

        print("✅ MAP: destination latitude \(destination.latitude) et longitude \(destination.longitude)")

        createRoute(to: CLLocationCoordinate2D(latitude: destination.latitude, longitude: destination.longitude))
        print("✅ MAP: route \(createRoute(to: CLLocationCoordinate2D(latitude: destination.latitude, longitude: destination.longitude)))")
    }

    func setupUser(latitude: Double, longitude: Double) {
        API.LocalisationCity.foundCountryByCoordinates(latitude: String(latitude), longitude: String(longitude)) { result in
            guard let cityInfo = result else { return }
            self.user = User(city: cityInfo)
            self.userNameLabel.text = self.user.welcomeMessage
            print("✅ MAP CELLPHONE USER: user City Name \(self.user.city.name ?? "Nothing"), in \(self.user.city.country ?? "Nothing") with country code : \(self.user.city.countryCode ?? "Nothing")")
            print("✅ MAP CELLPHONE USER: coordinates receive of \(self.user.name) are lat:\(self.user.city.latitude ?? 0) et long:\(self.user.city.longitude ?? 0)")
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
        guard let pinDestination = pinDestination else { return }

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

        let destinationCity = destination.city

        if destinationCity.latitude != 0 && destinationCity.longitude != 0  {
            pinDestination = PinMap(title: "you want to go to \(destinationCity.name ?? "No Land")",
                                    coordinate: CLLocationCoordinate2D(latitude: (destinationCity.latitude),
                                                                       longitude: (destinationCity.longitude)),
                                    info: "destination")
            print("✅ MAP: pin destination: \(pinDestination.title ?? "unknow")")
        }

        if let userCoordinates = currentLocationUser?.coordinate {
            pinUser = PinMap(title: "Hello \(user.name)! it's you!",
                             coordinate: CLLocationCoordinate2D(latitude: (userCoordinates.latitude),
                                                                longitude: (userCoordinates.longitude)),
                             info: "start")

            print("✅ MAP: pin user: \(pinUser?.title ?? "unknow")")
            print("📍 MAP: user latitude \(currentLocationUser?.coordinate.latitude ?? 0) et longitude \(currentLocationUser?.coordinate.latitude ?? 0)")
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
                print("Error of creation of route")
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
        let destinationCity = destination.city

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
            case "you want to go to \(destinationCity.name ?? "No Land")":
                annotationView?.image = UIImage(named: "pinDestination")
            case user.welcomeMessage:
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
        let destinationCity = destination.city
        let startPolyline = location.coordinate
        let destinationPolyline = CLLocationCoordinate2D(latitude: destinationCity.latitude, longitude: destinationCity.longitude)
        let coordinatesPolyline = [startPolyline, destinationPolyline]
        let polyline = MKPolyline(coordinates: coordinatesPolyline, count: coordinatesPolyline.count)

        mapView.addOverlay(polyline)

        let center = CLLocationCoordinate2D(latitude: (((currentLocationUser?.coordinate.latitude ?? 0) + destinationCity.latitude) / 2),
                                            longitude: (((currentLocationUser?.coordinate.longitude ?? 0) + destinationCity.longitude) / 2))
        let span = MKCoordinateSpan(latitudeDelta: 90, longitudeDelta: 90)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)

    }
}
