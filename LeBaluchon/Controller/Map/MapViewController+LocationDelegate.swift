//
//  MapViewController+LocationDelegate.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 14/12/2022.
//

import UIKit
import MapKit
import CoreLocation


    // -------------------------------------------------------
    //MARK: - found the user's coordinates
    // -------------------------------------------------------

extension MapViewController: CLLocationManagerDelegate {

    func setupLocationManager() {
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
        let destinationPolyline = CLLocationCoordinate2D(latitude: destination.latitude, longitude: destination.longitude)
        let coordinatesPolyline = [startPolyline, destinationPolyline]
        linePolyline = MKPolyline(coordinates: coordinatesPolyline, count: coordinatesPolyline.count)
        
        mapView.addOverlay(linePolyline)
        

        let center = CLLocationCoordinate2D(latitude: (((currentLocationUser?.coordinate.latitude ?? 0) + destination.latitude) / 2),
                                            longitude: (((currentLocationUser?.coordinate.longitude ?? 0) + destination.longitude) / 2))
        let span = MKCoordinateSpan(latitudeDelta: 80, longitudeDelta: 80)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
    }


        // -------------------------------------------------------
        // MARK: - map create route if possible
        // -------------------------------------------------------

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
            self.mapView.removeOverlay(self.linePolyline)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        }
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = .pinkGranada
        renderer.lineWidth = 10
        return renderer
    }
}
