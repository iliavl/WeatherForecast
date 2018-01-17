//
//  DateTableViewCell.swift
//  WeatherForecast
//
//  Created by LIV on 14.07.17.
//  Copyright © 2017 LIV. All rights reserved.
//

import UIKit

class FullCityListTableViewCell: UITableViewCell {

//    @IBOutlet weak var labelDate: UILabel!
//    
    @IBOutlet weak var labelCityCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureDate(city: String) {
        
        labelCityCell.text = city
    }
}
