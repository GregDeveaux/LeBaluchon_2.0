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

    var user: User?
    var destinationCity: DestinationCity?

    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let userName = user?.name else { return }
        userNameLabel.text = "\(userName), what's up!"

        setupLocationManager()
        setupMapView()
    }
}

extension MapViewController: MKMapViewDelegate {
    private func setupMapView() {
        mapView.delegate = self
        guard let userName = user?.name else { return }
        let pinUser = PinMap(title: "Vous êtes ici \(userName)",
                             coordinate: CLLocationCoordinate2D(latitude: (user?.coordinates?.latitude)!,
                                                                longitude: (user?.coordinates?.longitude)!),
                             info: "départ")

        guard let destinationName = destinationCity?.name else { return }
        let pinDestination = PinMap(title: "Vous allez à \(destinationName)",
                                    coordinate: CLLocationCoordinate2D(latitude: (destinationCity?.coordinates.latitude)!,
                                                                       longitude: (destinationCity?.coordinates.longitude)!),
                                    info: "destination")

        mapView.addAnnotations([pinUser, pinDestination])
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

        user?.coordinates?.latitude = location.coordinate.latitude
        user?.coordinates?.longitude = location.coordinate.longitude
    }
}
