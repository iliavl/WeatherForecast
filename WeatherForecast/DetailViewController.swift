//
//  DetailViewController.swift
//  WeatherForecast
//
//  Created by LIV on 26.07.17.
//  Copyright © 2017 LIV. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {
    
    @IBOutlet weak var picMain: UIImageView!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblPh: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var lblWindSpeed: UILabel!
    @IBOutlet weak var lblWindDirection: UILabel!
    @IBOutlet weak var lblSunrise: UILabel!
    @IBOutlet weak var lblSunset: UILabel!
    
    var delegate: ViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showInTable()
        
        
//        tableView.dataSource = self
//        tableView.delegate = self
    }
   
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        if segue.identifier == "ShowDetail" {
//            
//            let destinationVC = segue.destination as? ViewController
//            destinationVC?.delegate = self
//        }
//    }
 
    func showInTable() {
        
        let tableParameters = WeatherData.shared.parameters
        
        var mainPictureUrl = "https://openweathermap.org/img/w/"
        let icon = tableParameters["icon"] as! String
        mainPictureUrl += icon + ".png"
        
        if let checkedUrl = URL(string: mainPictureUrl) {
            
            picMain.contentMode = .scaleAspectFit
            downloadImageInView(url: checkedUrl)
        }
        
        var temp = tableParameters["temp"] as! Double
        temp -= 273.15
        temp = temp.rounded()
        lblTemp.text = String(format: "%.0f", temp)
        let pressure = tableParameters["pressure"] as! Double
        lblPh.text = String(format: "%.0f", pressure)
        let humidity = tableParameters["humidity"] as! Double
        lblHumidity.text = String(format: "%.0f", humidity)
        let speed = tableParameters["speed"] as! Double
        lblWindSpeed.text = String(format: "%.0f", speed)
        let deg = tableParameters["deg"] as! Double
        let degString = ConverterWindDirection(deg: deg)
        lblWindDirection.text = degString
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy - hh:mm a"
        let sunrise = tableParameters["sunrise"] as! Double
        var textSunrise = "only on today"
        
        if sunrise != 0.00 {
            let dateSunrise = Date(timeIntervalSince1970: sunrise)
            textSunrise = dateFormatter.string(from: dateSunrise)
            
        } else {
            
            textSunrise = "only on today"
        }
        
        lblSunrise.text = textSunrise
        var textSunset = "only on today"
        let sunset = tableParameters["sunset"] as! Double
        
        if sunset != 0.00 {
            
            let dateSunset = Date(timeIntervalSince1970: sunset)
            textSunset = dateFormatter.string(from: dateSunset)
            
        } else {
            
            textSunset = "only on today"
        }
        
        lblSunset.text = String(textSunset)
    }
    
    func downloadImageInView(url: URL) {
        
        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                let image = UIImage(data: data)
                self.picMain.image = image
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func ConverterWindDirection(deg: Double) -> String {
        
        var degString = ""
        
        if 0.00 <= deg && deg < 11.25 {
            degString = "N"
        } else if 11.25 <= deg && deg < 33.75 {
            degString = "NNE"
        } else if 33.75 <= deg && deg < 56.25 {
            degString = "NE"
        } else if 56.25 <= deg && deg < 78.75 {
            degString = "ENE"
        } else if 78.75 <= deg && deg < 101.25 {
            degString = "E"
        } else if 101.25 <= deg && deg < 123.75 {
            degString = "ESE"
        } else if 123.75 <= deg && deg < 146.25 {
            degString = "SE"
        } else if 146.25 <= deg && deg < 168.75 {
            degString = "SSE"
        } else if 168.75 <= deg && deg < 191.25 {
            degString = "S"
        } else if 191.25 <= deg && deg < 213.75 {
            degString = "SSW"
        } else if 213.75 <= deg && deg < 236.25 {
            degString = "SW"
        } else if 236.25 <= deg && deg < 258.75 {
            degString = "WSW"
        } else if 258.75 <= deg && deg < 281.25 {
            degString = "W"
        } else if 281.25 <= deg && deg < 303.75 {
            degString = "WNW"
        } else if 303.75 <= deg && deg < 326.25 {
            degString = "NW"
        } else if 326.25 <= deg && deg < 348.75 {
            degString = "NNW"
        } else if 348.75 <= deg && deg < 360 {
            degString = "N"
        } else {
        degString = ""
        }
        
        return degString
    }
}
