//
//  File.swift
//  ShoppingMadeEasy
//
//  Created by Ashish Jayaprakash Baheti (RIT Student) on 5/3/17.
//  Copyright © 2017 Ashish Baheti. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class StoreMatch: NSObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var matchList: [String] = []
    
    func checkForNearByStores(_ stores:[Store]) {
        
        var googleRequestUrl = ""
        matchList = []
        let latitude = String(locationManager.location!.coordinate.latitude)
        let longitude = String(locationManager.location!.coordinate.longitude)
        
        var storelist: [String] = []
        var storeTypes: [String] = []
        for store: Store in stores {
            storelist.append(store.name!)
            if !storeTypes.contains(store.type!) {
                storeTypes.append(store.type!)
            }
        }
        
        var distance = 500
        if let x = UserDefaults.standard.object(forKey: "perimeter") as? Int{
            distance = x
        }
        print(distance)
        // https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=37.33770858,-122.02473448&radius=7565&types=department_store&key=AIzaSyDyE-6Z-OLdXADVycJ4nfpDxnJqyeS5C6M
        
        for name in storeTypes {
            googleRequestUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location="
            googleRequestUrl += latitude + "," + longitude
            googleRequestUrl += "&radius=" + String(distance)
            googleRequestUrl += "&types=" + name
            googleRequestUrl += "&key=" + GOOGLE_PLACES_KEY
            
            print("\(googleRequestUrl)")
            
            let placesUrl = URL(string: googleRequestUrl)
            let session = URLSession.shared
            let loadDataTAsk = session.dataTask(with: placesUrl!, completionHandler: {(data: Data?, response: URLResponse?, error: Error?)-> Void in
                
                if let responseError = error {
                    //display alert...maybe on a background thread
                    print(responseError)
                } else if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode != 200 {
                        let statusError = NSError(domain: "com.baheti.ashish", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey:"HTTP status code has unexpected value."])
                        //display alert...maybe on background thread
                        print(statusError)
                    } else {
                        let json = try? JSON(data: data!)
                        let x = (json?["results"].array)!
                        
                        for a in x {
                            let name = a["name"].description
                            
                            if storelist.contains(name) {
                                print(name+"----- Match")
                                
                                DispatchQueue.main.async {
                                    let storeVC = StoresTVC()
                                    storeVC.createNoti(name: name)
                                }
                            }
                        }
                    }
                }
            })
            
            loadDataTAsk.resume()
        }
    }
}
