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

    var userName = ""
    var destinationCityName = ""
    var textButton = "Modify the destination"

    var user: User!
    var destinationCity: DestinationCity!

    var pinUser: PinMap!
    var pinDestination: PinMap!

    let locationManager = CLLocationManager()
    var userCoordinates: CLLocationCoordinate2D!

    override func viewDidLoad() {
        super.viewDidLoad()

        userNameLabel.text = "\(userName), what's up!"
        
        setupLocationManager()
        setupMapView()
//        setupUser()

        print("✅\(String(describing: userCoordinates))")

    }

//    private func setupUser() {
//        user = User(name: userName, coordinates: userCoordinates)
//        userNameLabel.text = user.welcomeMessage
//    }



    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
        } else {

        }
    }

}

extension MapViewController: MKMapViewDelegate {
    private func setupMapView() {
        mapView.delegate = self

        user?.name = userName

        destinationCity.name = destinationCityName
        if let latitudeOfDestination = destinationCity?.coordinates.latitude,
            let longitudeOfDestination = destinationCity?.coordinates.longitude {

            pinDestination = PinMap(title: "Vous allez à \(destinationCityName)",
                                    coordinate: CLLocationCoordinate2D(latitude: (latitudeOfDestination),
                                                                       longitude: (longitudeOfDestination)),
                                    info: "destination")
            print("pin destination: \(pinDestination!)")
        }

//        if let latitudeUser = user?.coordinates.latitude,
//            let longitudeUser = user?.coordinates.longitude {
//            pinUser = PinMap(title: "Vous êtes ici \(user?.name ?? "unknow")",
//                             coordinate: CLLocationCoordinate2D(latitude: (latitudeUser),
//                                                                longitude: (longitudeUser)),
//                             info: "départ")
//            print(pinUser!)
//        }
//        mapView.addAnnotations([pinUser, pinDestination])
        mapView.addAnnotation(pinDestination)
    }

    func getRoute(to destinationCity: MKMapItem) {
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
        guard annotation is PinMap else { return nil}

            // custom pinUser
        let annotationDestinationView = MKAnnotationView(annotation: pinDestination, reuseIdentifier: "pinDestination")
        annotationDestinationView.image = UIImage(named: "pinDestination")
        annotationDestinationView.frame.size = CGSize(width: 150, height: 90)
        return annotationDestinationView
    }
}


    //MARK: found the user's coordinates for show the pin on the map
extension MapViewController: CLLocationManagerDelegate {

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("-----00000-00000------00000------\(locations)")
            //        self.mapView.showsUserLocation = true

            // stop location user and recover the coordinates
        guard let currentLocation = locations.first else { return }

        let center = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)

        pinUser = PinMap(title: "Vous êtes ici \(user?.name ?? "unknow")",
                         coordinate: CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude,
                                                            longitude: currentLocation.coordinate.longitude),
                             info: "départ")
            print(pinUser!)
        mapView.addAnnotation(pinUser)
    }
    

//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        checkLocationAuthorization()
//    }
}
