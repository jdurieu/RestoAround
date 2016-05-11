//
//  Resto+Json.swift
//  RestoAround
//
//  Created by Jonathan Durieu on 19/04/16.
//  Copyright © 2016 Jonathan Durieu. All rights reserved.
//


import Foundation
import SwiftyJSON



extension Resto {
    convenience init?(json:JSON) {
        self.init()
        
        if let latitude = json["lat"].string {
            self.latitude = Float(latitude)
        }
        
        if let longitude = json["lng"].string {
            self.longitude = Float(longitude)
        }
        
        if let name = json["titleNoFormatting"].string{
            self.name = name
        }
        
        self.urlDetail = json["detailUrl"].string

}
}