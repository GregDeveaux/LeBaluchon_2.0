//
//  PinMap.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 06/11/2022.
//

import UIKit
import MapKit

class PinMap: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String

    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
