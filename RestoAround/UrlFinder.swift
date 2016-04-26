//
//  UrlFinder.swift
//  RestoAround
//
//  Created by Jonathan Durieu on 20/04/16.
//  Copyright © 2016 Jonathan Durieu. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UrlFinder {
    
    typealias RestoResult = (restos:[Resto]) -> Void
    
    static func findUrl(resto: Resto) {
        
        
        
        let url = resto.urlDetail
        
        Alamofire.request(.GET, url).responseData { (response) in
            
            if let data = response.data{
                let json = JSON (data: data)
                let results = json ["result"]
            
                if let primary = results["contactInfo"].array {
                    
                    var resto = Resto.init()
                
                if let results = json["result"].array{
                    var allRestos = [Resto]()
                    
                    for jsonObject in results {
                        if let resto = Resto(json: jsonObject){
                            /*
                             
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
                   // result(restos: allRestos)
                    
                }
            }
        }
    }
}
}