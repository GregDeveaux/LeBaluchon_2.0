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

        // properties for receive data of the segue
    var userName = ""
    var destinationCityName = ""
    var textButton = "Modify the destination"

    var user: User!
    var destinationCity: DestinationCity!

    var pinUser: PinMap!
    var pinDestination: PinMap!

    let locationManager = CLLocationManager()
    var currentLocationUser: CLLocationCoordinate2D!
    var route: MKRoute!

    override func viewDidLoad() {
        super.viewDidLoad()

        userNameLabel.text = "\(userName), what's up!"

        setMapView()
        setupLocationManager()
    }

    func setupUser(latitude: Double, longitude: Double) -> User {
        print("✅ coordinates receive of user are lat:\(latitude) et long:\(longitude))")
        return User(name: userName, coordinates: Coordinates(latitude: latitude, longitude: longitude))
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
//        mapView.addAnnotation(pinDestination)
    }


    private func setupPinMap() {

        if let coordinatesDestination = destinationCity?.coordinates {
            pinDestination = PinMap(title: "Vous allez à \(destinationCityName)",
                                    coordinate: CLLocationCoordinate2D(latitude: (coordinatesDestination.latitude),
                                                                       longitude: (coordinatesDestination.longitude)),
                                    info: "destination")
            print("✅ pin destination: \(pinDestination.title ?? "unknow")")
        }

        if let userCoordinates = currentLocationUser {
            pinUser = PinMap(title: "Hello \(user?.name ?? "unknow")! it's you!",
                             coordinate: CLLocationCoordinate2D(latitude: (userCoordinates.latitude),
                                                                longitude: (userCoordinates.longitude)),
                             info: "start")
            print("✅ pin destination: \(pinUser.title ?? "unknow")")
        }
    }

    func getRoute(to destinationCity: MKMapItem) {
        let userCoordinates = CLLocationCoordinate2D(latitude: user.coordinates.latitude,
                                                     longitude: user.coordinates.longitude)

        let userPlacemark = MKPlacemark(coordinate: userCoordinates)
        let userMapItem = MKMapItem(placemark: userPlacemark)

        let request = MKDirections.Request()
        request.source = userMapItem
        request.destination = destinationCity
        request.transportType = .transit

        let directions = MKDirections(request: request)

        directions.calculate { response, error in
            guard let response = response else { return }

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
        

        annotationView = MKAnnotationView(annotation: pinDestination, reuseIdentifier: "customPin")
        annotationView?.image = UIImage(named: "pinDestination")
        annotationView?.frame.origin = CGPoint(x: 150, y: 135)
        annotationView?.frame.size = CGSize(width: 150, height: 90)



//        let annotationUserView = MKAnnotationView(annotation: pinUser, reuseIdentifier: "pinUser")
//        annotationUserView.image = UIImage(named: "pinUser")
//        annotationUserView.frame.size = CGSize(width: 150, height: 90)

        return annotationView
    }
}


    //MARK: found the user's coordinates for show the pin on the map
extension MapViewController: CLLocationManagerDelegate {

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        currentLocationUser = manager.location?.coordinate

        user = setupUser(latitude: currentLocationUser.latitude, longitude: currentLocationUser.longitude)
        print("📍 latitude \(currentLocationUser.latitude) et longitude \(currentLocationUser.latitude)")


//            // recover and update the coordinates of user
//        user = setupUser(latitude: locations.first!.coordinate.latitude, longitude: locations.first!.coordinate.latitude)
//
//                                        pinUser = PinMap(title: "Hello \(user.name)! it's you!",
//                                                         coordinate: CLLocationCoordinate2D(latitude: (user.coordinates.latitude),
//                                                                                            longitude: (user.coordinates.longitude)),
//                                                         info: "start")
//                                        print("✅ pin user: \(pinUser.title ?? "unknow")")
//                                        mapView.addAnnotation(pinUser)
//
//        let center = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
//        let span = MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
//        let region = MKCoordinateRegion(center: center, span: span)
//        mapView.setRegion(region, animated: true)

    }
}
