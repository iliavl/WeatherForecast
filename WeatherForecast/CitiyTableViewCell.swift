//
//  CitiyTableViewCell.swift
//  WeatherForecast
//
//  Created by LIV on 10.07.17.
//  Copyright © 2017 LIV. All rights reserved.
//

import UIKit

class CitiyTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var labelCityCell: UILabel!


    func configure(description: String)  {
        
        labelCityCell.text = description
    }
}
