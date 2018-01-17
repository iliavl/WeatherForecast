//
//  WeatherData.swift
//  WeatherForecast
//
//  Created by LIV on 27.07.17.
//  Copyright © 2017 LIV. All rights reserved.
//

import UIKit

class WeatherData: NSObject {

    static let shared = WeatherData()
    
    var parameters = ["temp":0.00, "pressure":0.00, "humidity":0.00, "id":0, "icon":"", "main":"", "description":"", "speed":0.00, "deg":0.00, "country":"", "sunrise":0.00, "sunset":0.00] as [String : Any]
}
