//
//  WeathersStructures.swift
//  WeatherForecast
//
//  Created by LIV on 26.07.17.
//  Copyright © 2017 LIV. All rights reserved.
//

import Foundation

struct Weather {
    
    let id: Int
    let icon: String
    let main: String
    let description: String
    
    
    init(id: Int, icon: String, main: String, description: String) {
        
        self.id = id
        self.icon = icon
        self.main = main
        self.description = description
        print("init: \(id)_\(icon)_\(main)_\(description)")
    }
}

struct Main {
    
    let temp: Double
    let pressure: Double
    let humidity: Double
    
    init(temp: Double, pressure: Double, humidity: Double) {
        
        self.temp = temp
        self.pressure = pressure
        self.humidity = humidity
        print("init: \(temp)_\(pressure)_\(humidity)")
    }
}

struct Wind {
    
    let speed: Double
    let deg: Double
    
    init(speed: Double, deg: Double) {
        
        self.speed = speed
        self.deg = deg
        print("init: \(speed)_\(deg)")
    }
}

struct System {
    
    let country: String
    let sunrise: Double
    let sunset: Double
    
    init(country: String, sunrise: Double, sunset: Double) {
        
        self.country = country
        self.sunrise = sunrise
        self.sunset = sunset
        print("init: \(country)_\(sunrise)_\(sunset)")
    }
}

struct Cities {
    
    
    let city: String
    
    init(city: String) {
        
        self.city = city
        print("init: \(city)")
    }
}

struct CitiesFCL {
    
    let city: String
    
    init(city: String) {
        
        self.city = city
        print("init: \(city)")
    }
}
