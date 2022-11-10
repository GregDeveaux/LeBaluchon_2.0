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

    override func viewDidLoad() {
        super.viewDidLoad()

        userNameLabel.text = "\(userName), what's up!"
        

        setupLocationManager()
        setupMapView()
        
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
            print(pinDestination!)
        }

        if let latitudeUser = user?.coordinates.latitude,
            let longitudeUser = user?.coordinates.longitude {
            pinUser = PinMap(title: "Vous êtes ici \(user?.name ?? "unknow")",
                             coordinate: CLLocationCoordinate2D(latitude: (latitudeUser),
                                                                longitude: (longitudeUser)),
                             info: "départ")
            print(pinUser!)
        }
//        mapView.addAnnotations([pinUser, pinDestination])
        mapView.addAnnotation(pinDestination)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: pinUser, reuseIdentifier: "pinUser")
        annotationView.image = UIImage(named: "pinDepart")
        annotationView.frame.size = CGSize(width: 150, height: 90)
        return annotationView
    }
}

extension MapViewController: CLLocationManagerDelegate {

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        let location = locations[0]
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        let personLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

        let coordinateRegion = MKCoordinateRegion(center: personLocation, span: coordinateSpan)

        mapView.setRegion(coordinateRegion, animated: true)
        self.mapView.showsUserLocation = true

        user?.coordinates.latitude = location.coordinate.latitude
        user?.coordinates.longitude = location.coordinate.longitude
    }
}
