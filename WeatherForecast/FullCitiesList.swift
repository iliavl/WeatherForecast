//
//  FullCitiesList.swift
//  WeatherForecast
//
//  Created by LIV on 22.07.17.
//  Copyright © 2017 LIV. All rights reserved.
//

import Foundation
import RealmSwift

class FullCitiesList: Object {
    
    dynamic var name = ""
    dynamic var id = 0
    dynamic var country = ""
    
    convenience init(name: String, id: Int, country: String) {
        
        self.init()
        self.name = name
        self.id = id
        self.country = country
    }
}
