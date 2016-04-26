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
    
    typealias RestoResult = (restos:[Resto]) -> Void
    
    static func findRestoAround(latitude: Double, longitude: Double, result: RestoResult) {
        
        
        let url = "https://db.aroundmeapi.com/v3/categorysearch/restaurant?lat=\(latitude)&lon=\(longitude)"
        
        Alamofire.request(.GET, url).responseData { (response) in
            
            if let data = response.data {
                let json = JSON(data: data)
                
                if let results = json["result"].array{
                 var allRestos = [Resto]()
                    
                    for jsonObject in results {
                        if let resto = Resto(json: jsonObject){
                            /*
                            Alamofire.request(.GET,resto.urlDetail).responseData{ (response) in
                                
                                if let data = response.data{
                                    let json = JSON (data: data)
                                    let results = json ["result"]
                                    
                                    if let primary = results["contactInfo"].array {
                                        var resto = resto
                                        
                                        for jsonObject in primary {
                                            if let bar = Bar(json: jsonObject) {
                                                allBars.append(bar)
                                            }
                                        }

                                    
                                    
                                    }
                                    
                                    )
                                
                                }
                            
                            
                            
                            
                            
                            }
                            
                            */
                            
                            
                            
                            allRestos.append(resto)

                        }
                    }
                    result(restos: allRestos)
                    
                }
            }
        }
    }
    
}