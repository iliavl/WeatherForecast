//
//  WeatherForecastCities.swift
//  WeatherForecast
//
//  Created by LIV on 19.07.17.
//  Copyright © 2017 LIV. All rights reserved.
//
import UIKit

class WeatherForecastCity: NSObject {
    
    let name: String
    let id: Int
    let country: String
    
    init(name: String, id: Int, country: String) {
        
        self.name = name
        self.id = id
        self.country = country
    }
}

