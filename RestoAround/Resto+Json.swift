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
    init?(json:JSON) {
        
        if let name = json["titleNoFormatting"].string, latitude = json["lat"].string, longitude = json["lng"].string{
            self.name = name
            self.latitude = Double(latitude)
            self.longitude = Double(longitude)
            self.urlDetail = json["detailUrl"].string
        }else{
            return nil
        }
    }
}