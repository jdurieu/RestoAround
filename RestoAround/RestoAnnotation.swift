//
//  RestoAnnotation.swift
//  RestoAround
//
//  Created by Jonathan Durieu on 19/04/16.
//  Copyright © 2016 Jonathan Durieu. All rights reserved.
//

import Foundation
import MapKit

class RestoAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var resto:Resto!
    
    
    init(resto: Resto) {
        self.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(resto.latitude), CLLocationDegrees(resto.longitude))
        self.title = resto.name
        self.subtitle = nil
    }
    
}