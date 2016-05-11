//
//  RestoFinder.swift
//  RestoAround
//
//  Created by Jonathan Durieu on 19/04/16.
//  Copyright © 2016 Jonathan Durieu. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RestoFinder {
    
    internal typealias RestoResult = (restos:[Resto]) -> Void
    internal typealias RestoDetailResult = (restoUrl:String?) -> Void
    
    class func findRestoAround(latitude: Double, longitude: Double, resultHandler: RestoResult) {
        
        
        let url = "https://db.aroundmeapi.com/v3/categorysearch/restaurant?lat=\(latitude)&lon=\(longitude)"
        
        Alamofire.request(.GET, url).responseData { (response) in
            
            var restos = [Resto]()
            
            if let data = response.data {
                let json = JSON(data: data)
                
                if let results = json["result"].array{
                    
                    for jsonObject in results {
                        if let resto = Resto(json: jsonObject){
                            restos.append(resto)
                        }
                    }
                    resultHandler(restos: restos)
                    
                }
            }
        }
    }
    
    
    class func findRestoDetail (resto: Resto, restoDetailHandler:RestoDetailResult){
    
        if let detailUrl = resto.urlDetail {
            Alamofire.request(.GET, detailUrl).responseData(completionHandler: { (response) in
                if let data = response.data {
                    let jsonRoot = JSON(data: data)
                    
                    var resultUrl:String?
                    
                    if let contactInfos = jsonRoot["result"]["contactInfo"].array {
                        for contactInfo in contactInfos {
                            if let type = contactInfo["Type"].string, attribute = contactInfo["Attribute"].string where type=="u" && !attribute.containsString("maps.google.com") {
                                
                                resultUrl = attribute
                            }
                        }
                    }
                    
                    restoDetailHandler(restoUrl: resultUrl)
                }
            })

    
    
    }
    }
}