//
//  ViewController.swift
//  WeatherForecast
//
//  Created by LIV on 05.07.17.
//  Copyright © 2017 LIV. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

protocol ViewControllerDelegate {
    
    func detailWeather(parameters: [[String: Any]])
}

class ViewController: UIViewController, CityListViewControllerDelegate, FullCitiesListViewControllerDelegate {
    
    @IBOutlet weak var labelCountry: UILabel!
    @IBOutlet weak var textFieldCity: UITextField!
    @IBOutlet weak var stackViewMainWether: UIStackView!
    @IBOutlet weak var imageMainWether: UIImageView!
    @IBOutlet weak var labelTemperature: UILabel!
    @IBOutlet weak var labelGradus: UILabel!
    @IBOutlet weak var btnShortCityList: UIButton!
    @IBOutlet weak var btnFullCitiesList: UIButton!
    @IBOutlet weak var tfDate: UITextField!
    @IBOutlet weak var stkMainWether: UIStackView!
    @IBOutlet weak var stkCityList: UIStackView!
    @IBOutlet weak var stkDBCityList: UIStackView!
    @IBOutlet weak var btnAddToFav: UIButton!
    @IBOutlet weak var btnDetail: UIButton!
    @IBOutlet weak var btn_DelFav: UIButton!
    
    var delegate: ViewControllerDelegate?
    var weathers = [Weather]()
    var weathersMains = [Main]()
    var weathersWinds = [Wind]()
    var weathersSystem = [System]()
    var delegateParameters = [[String: Any]]()
    var firstLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var stringCityName = "Kiev"
        //realmDeleteObjectFromDB()
        loadDataJsonFromFileCitiesList()
        
        if let setCity = UserDefaults.standard.object(forKey: "cityName") as? String {
            
            textFieldCity.text = setCity
        }

        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let formattingDate = formatter.string(from: date)
        tfDate.text = formattingDate
        
        if textFieldCity.text == "city" {
            textFieldCity.text = stringCityName
        }
        stringCityName = textFieldCity.text!
        loadDataJson(cityName: stringCityName)
        setLabels()
        setupUI()
        print("End of code. The image will continue downloading in the background and it will be loaded when it ends.")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if firstLoad {

            btnAddToFav.center.x -= view.bounds.width
            btn_DelFav.center.y += view.bounds.height
            btnDetail.center.y += view.bounds.height
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        btnAddToFav.isHidden = false
        btn_DelFav.isHidden = false
        
        if firstLoad {
            
            UIView.animate(withDuration: 0.9) {
                
                self.btnAddToFav.center.x += self.view.bounds.width
                self.btnDetail.center.y = self.view.bounds.height
            }
            
            UIView.animate(withDuration: 1.9) {
                
                self.btn_DelFav.center.y -= self.view.bounds.height
            }
            btnDetail.isHidden = false
            firstLoad = false
        }
    }
    
    @IBAction func btnADetail(_ sender: UIButton) {
        
        //setWeatherData()
    }
    
    @IBAction func btnAShortCityList(_ sender: UIButton) {
        
        performSegue(withIdentifier: "ShowCitiesList", sender: self)
    }
    
    @IBAction func btnAFullCitiesList(_ sender: UIButton) {
        
        performSegue(withIdentifier: "ShowFullCitiesList", sender: self)
    }
    
    @IBAction func btnDateList(_ sender: UIButton) {
        
    }
    
    @IBAction func tbaDate(_ sender: UITextField) {
        
    }
    
    private func returnToolBar() -> UIToolbar {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.barTintColor = UIColor.blue
        toolBar.sizeToFit()
        toolBar.frame = CGRect(x: toolBar.frame.origin.x,
                               y: toolBar.frame.origin.y,
                               width: toolBar.frame.width,
                               height: 40.0)
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done",
                                         style: .plain,
                                         target: self,
                                         action: #selector(self.setDateInTextField))
        
        doneButton.tintColor = UIColor.red
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }
    
    @objc func setDateInTextField() {
        
        tfDate.resignFirstResponder()
    }
    
    private func setupUI() {
        
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        datePickerView.minimumDate = Date()
        let datemax = Calendar.current.date(byAdding: .day, value: 15, to: Date())
        datePickerView.maximumDate = datemax
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        
        tfDate.inputView = datePickerView
        let toolBar = returnToolBar()
        tfDate.inputAccessoryView = toolBar
        
        self.view.backgroundColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 255.0/255.0, alpha: 1)
        
    }
  
    @IBAction func btnShortList(_ sender: UIButton) {
        
    }
    
    @IBAction func btnSetSetting(_ sender: UIButton) {
        
        UserDefaults.standard.set(textFieldCity.text, forKey: "cityName")
    }
    
    @IBAction func btnRestoreSetting(_ sender: UIButton) {
        
        loadDefault()
    }
    
    @IBAction func btnAddFav(_ sender: UIButton) {
        
        guard let cityName = textFieldCity.text else {
            print("wrong city name")
            return
        }
        
        realmAddToDBFav(name: cityName, id: 1, country: "UK")
        //addToDBCoreData(name: cityName, id: 1, country: "UK")
    }
    
    @IBAction func btnDelFav(_ sender: UIButton) {
        
        realmDeleteObjectFromDBWithFilter()
    }
    
    @IBAction func btnClearFav(_ sender: UIButton) {
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        tfDate.text = dateFormatter.string(from: sender.date)
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: Date())
        let date2 = calendar.startOfDay(for: sender.date)
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        let day = components.day
        loadDataJsonAfterChangeDay(cityName: textFieldCity.text!, day: day!)
    }
    
    func doneButton(sender: UIButton) {
        
        tfDate.resignFirstResponder() // To resign the inputView on clicking done.
    }
    
    func downloadImageInView(url: URL) {
        
        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                let image = UIImage(data: data)
                self.imageMainWether.image = image
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func loadDataJson(cityName: String) {
        
        let parameter = cityName
        let urlString = "http://api.openweathermap.org/data/2.5/weather?q=\(parameter),ua&appid=85746c1a71f32f724002f7ebeb68dafa"
        
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                print("request is done")
                
                if let jsonData = data {
                    do {
                        
                        if let json = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] {
                            print(jsonData)
                            
                            if let weatherArray = json["weather"] as? [[String: Any]] {
                                
                                for weather in weatherArray {
                                    
                                    let id = weather["id"] as! Int
                                    let icon = weather["icon"] as! String
                                    let main = weather["main"] as! String
                                    let description = weather["description"] as! String
                                    self.weathers.append(Weather(id: id, icon: icon, main: main, description: description))
                                    
                                    WeatherData.shared.parameters["id"] = id
                                    WeatherData.shared.parameters["icon"] = icon
                                    WeatherData.shared.parameters["main"] = main
                                    WeatherData.shared.parameters["description"] = description
                                }
                            }
                            
                            if let weatherMain = json["main"] as? [String: Any] {
                                
                                let temp = weatherMain["temp"] as! Double
                                let pressure = weatherMain["pressure"] as! Double
                                let humidity = weatherMain["humidity"] as! Double
                                self.weathersMains.append(Main(temp: temp, pressure: pressure, humidity: humidity))
                                
                                WeatherData.shared.parameters["temp"] = temp
                                WeatherData.shared.parameters["pressure"] = pressure
                                WeatherData.shared.parameters["humidity"] = humidity
                            }
                            
                            if let weatherWind = json["wind"] as? [String: Any] {
                                
                                let speed = weatherWind["speed"] as! Double
                                //let deg = weatherWind["deg"] as! Double
                                let deg = 330.00
                                self.weathersWinds.append(Wind(speed: speed, deg: deg))
                                
                                WeatherData.shared.parameters["speed"] = speed
                                WeatherData.shared.parameters["deg"] = deg
                           }
                            
                            if let weatherSystem = json["sys"] as? [String: Any] {
                                
                                let country = weatherSystem["country"] as! String
                                let sunrise = weatherSystem["sunrise"] as! Double
                                let sunset = weatherSystem["sunset"] as! Double
                                self.weathersSystem.append(System(country: country, sunrise: sunrise, sunset: sunset))
                                
                                WeatherData.shared.parameters["country"] = country
                                WeatherData.shared.parameters["sunrise"] = sunrise
                                WeatherData.shared.parameters["sunset"] = sunset
                            }
                            
                           
                            var mainPictureUrl = "https://openweathermap.org/img/w/"
                            mainPictureUrl += self.weathers[0].icon + ".png"
                            
                            if let checkedUrl = URL(string: mainPictureUrl) {
                                
                                self.imageMainWether.contentMode = .scaleAspectFit
                                self.downloadImageInView(url: checkedUrl)
                            }
                            DispatchQueue.main.async {
                                
                                self.labelTemperature.text = String(lround(self.weathersMains[0].temp - 273.15))
                                self.labelCountry.text = self.weathersSystem[0].country
                            }
                        }
                            
                        else {
                            print("error data")
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                } else {
                    print("data is nil")
                }
            }
            
            task.resume()
            print("request is started")
        }
    }
    
    private func setLabels() {
        
        labelCountry.layer.borderWidth = 3.0
        labelCountry.layer.borderColor = UIColor.brown.cgColor
        labelCountry.backgroundColor = UIColor.yellow
        labelCountry.layer.cornerRadius = labelCountry.frame.width/2
        labelCountry.layer.masksToBounds = true
        btnShortCityList.layer.borderColor = UIColor.green.cgColor
        btnFullCitiesList.layer.borderColor = UIColor.cyan.cgColor
        btnAddToFav.frame.origin = CGPoint(x: view.frame.size.width - btnAddToFav.frame.size.width, y: textFieldCity.frame.origin.y)
        btnAddToFav.layer.borderWidth = 2.0
        btnAddToFav.layer.borderColor = UIColor.gray.cgColor
        stkCityList.backgroundColor = UIColor.brown
        //stkCityList.borderColor = UIColor.green.cgColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowCitiesList" {
            
            let destinationVC = segue.destination as! CitiesListViewController
            destinationVC.delegate = self
            
        } else if segue.identifier == "ShowFullCitiesList" {
            
            let destinationVC = segue.destination as! FullCitiesListViewController
            destinationVC.delegate = self
            
        } else if segue.identifier == "ShowInDetail" {
            
            delegate?.detailWeather(parameters: delegateParameters)
        }
    }
    
    func fillTheTextFieldCity(description: String) {
        
        textFieldCity.text = description
        weathers = [Weather]()
        weathersMains = [Main]()
        weathersWinds = [Wind]()
        weathersSystem = [System]()
        loadDataJson(cityName: description)
    }
    
    private func addToDBCoreData(name: String, id: Int, country: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let wFCity = FavCities(context: context)
        wFCity.name = name
        wFCity.idCity = Int16(id)
        wFCity.country = country
        
        appDelegate.saveContext()
        
        print("adding city to DB /name/ \(name)")
    }
    
    private func loadFromDBCoreData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        //context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        do {
            let result = try context.fetch(FavCities.fetchRequest())
            
            if let cities = result as? [FavCities] {
                
                for city in cities {
                    
                    if let name = city.name {
                        
                        print("name \(name)")
                    }
                }
            }
            
        } catch {
            
            print(error)
        }
    }
    
    private func realmAddToDBFav(name: String, id: Int, country: String) {
        
        do {
            let realm = try Realm()
            
            try realm.write {
                
                let city = City(name: textFieldCity.text!, id: 1, country: "UK")
                realm.add(city)
            }
            
        } catch let error {
            print(error)
        }
        // path to DB
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    private func realmCreationDBFullCitiesList(name: String, id: Int, country: String) {
        
        do {
            let realm = try Realm()
            
            try realm.write {
                
                let city = FullCitiesList(name: name, id: id, country: country)
                realm.add(city)
                print("add element to DB \(city)")
            }
            
        } catch let error {
            print(error)
        }
        // path to DB
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    private func loadDataJsonFromFileCitiesList() {
        
        do {
            let realm = try Realm()
            let entities = realm.objects(FullCitiesList.self)
            if entities.isEmpty {
                print("Data Base \"FullCityList\" is empty")
                do {
                    if let file = Bundle.main.url(forResource: "citylist", withExtension: "json") {
                        let data = try Data(contentsOf: file)
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        if let object = json as? [[String: Any]] {
                            // json is a dictionary
                            
                            //if let namesArray = object["name"] as? [[String: Any]] {
                            
                            for city in object {
                                
                                let name = city["name"] as! String
                                let id = city["id"] as! Int
                                let country = city["country"] as! String
                                
                                if country == "UA" {
                                    realmCreationDBFullCitiesList(name: name, id: id, country: country)
                                }
                            }
                            
                            print(object)
                            
                        } else if let object = json as? [Any] {
                            // json is an array
                            print(object)
                        } else {
                            print("JSON is invalid")
                        }
                    } else {
                        print("no file")
                    }
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                print("Data Base \"FullCityList\" is exist")
            }
        } catch let error {
            print(error)
        }
    }
    
    private func realmDeleteAllFromDB() {
        
        do {
            let realm = try Realm()
            print(Realm.Configuration.defaultConfiguration.fileURL!)
            print("Try delete all data from base")
            try realm.write {
                
                realm.deleteAll()
                print("finish, deleted all data from base")
            }
            
        } catch let error {
            print(error)
        }
    }
    
    private func realmDeleteObjectFromDB() {
        
        do {
            let realm = try Realm()
            print(Realm.Configuration.defaultConfiguration.fileURL!)
            print("Try delete object in base")
            try realm.write {
                
                let objectcToDelete = realm.objects(FullCitiesList.self)
                
                for obj in objectcToDelete {
                    
                    realm.delete(obj)
                    print("deleting object from base")
                }
                
                print("finish, deleted object from base")
            }
            
        } catch let error {
            print(error)
        }
    }
    
    private func realmDeleteObjectFromDBWithFilter() {
        
        do {
            let realm = try Realm()
            print(Realm.Configuration.defaultConfiguration.fileURL!)
            print("Try delete object in base")
            try realm.write {
                
                if let name = textFieldCity.text {
                    let objectcToDelete = realm.objects(City.self).filter("name = '\(name)'")
                    
                    for obj in objectcToDelete {
                        
                        realm.delete(obj)
                        print("deleting object \(obj) from base")
                    }
                    
                    print("finish, deleted object from base")
                }
            }
        } catch let error {
            print(error)
        }
    }
    
    func setWeatherData() {
        
        if !weathersMains.isEmpty {
            
            let temp = weathersMains[0].temp
            let pressure = weathersMains[0].pressure
            let humidity = weathersMains[0].humidity
            
            WeatherData.shared.parameters["temp"] = temp
            WeatherData.shared.parameters["pressure"] = pressure
            WeatherData.shared.parameters["humidity"] = humidity
        }
        
        if !weathers.isEmpty {
            
            let id = weathers[0].id
            let icon = weathers[0].icon
            let main = weathers[0].main
            let description = weathers[0].description
            
            WeatherData.shared.parameters["id"] = id
            WeatherData.shared.parameters["icon"] = icon
            WeatherData.shared.parameters["main"] = main
            WeatherData.shared.parameters["description"] = description
        }
        
        if !weathersWinds.isEmpty {
            
            let speed = weathersWinds[0].speed
            let deg = weathersWinds[0].deg
            
            WeatherData.shared.parameters["speed"] = speed
            WeatherData.shared.parameters["deg"] = deg
        }
        
        if !weathersSystem.isEmpty {
            
            let country = weathersSystem[0].country
            let sunrise = weathersSystem[0].sunrise
            let sunset = weathersSystem[0].sunset
            
            WeatherData.shared.parameters["country"] = country
            WeatherData.shared.parameters["sunrise"] = sunrise
            WeatherData.shared.parameters["sunset"] = sunset
        }
        
        //WeatherData.shared.parameters = parameters
    }
    
    func loadDataJsonAfterChangeDay(cityName: String, day: Int) {
        
        let parameter = cityName
        let urlString = "http://api.openweathermap.org/data/2.5/forecast/daily?q=\(parameter),ua&cnt=16&appid=85746c1a71f32f724002f7ebeb68dafa"
        
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                print("request is done")
                
                if let jsonData = data {
                    do {
                        
                        if let json = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] {
                            print(jsonData)
                            
                            if let weatherArray = json["list"] as? [[String: Any]] {
                                
                                if weatherArray.count >= day {
                                    
                                    let wd1 = weatherArray[day]
                                    let wd2 = wd1["weather"] as! [[String: Any]]
                                    let weather = wd2[0]
                                    let id = weather["id"] as! Int
                                    let icon = weather["icon"] as! String
                                    let main = weather["main"] as! String
                                    let description = weather["description"] as! String
                                 
                                    
                                    self.weathers.append(Weather(id: id, icon: icon, main: main, description: description))
                                    
                                    let weatherTemp = wd1["temp"] as! [String: Any]
                                    let temp = weatherTemp["day"] as! Double
                                    let pressure = wd1["pressure"] as! Double
                                    let humidity = wd1["humidity"] as! Double
                                    self.weathersMains.append(Main(temp: temp, pressure: pressure, humidity: humidity))
                                    
                                    let speed = wd1["speed"] as! Double
                                    //let deg = wd1["deg"] as! Double
                                    let deg = 330.00
                                    self.weathersWinds.append(Wind(speed: speed, deg: deg))
                                    
                                    WeatherData.shared.parameters["id"] = id
                                    WeatherData.shared.parameters["icon"] = icon
                                    WeatherData.shared.parameters["main"] = main
                                    WeatherData.shared.parameters["description"] = description
                                    WeatherData.shared.parameters["speed"] = speed
                                    WeatherData.shared.parameters["deg"] = deg
                                    WeatherData.shared.parameters["temp"] = temp
                                    WeatherData.shared.parameters["pressure"] = pressure
                                    WeatherData.shared.parameters["humidity"] = humidity
                                }
                            }
                            
                            if let weatherSystem = json["city"] as? [String: Any] {
                                
                                let country = weatherSystem["country"] as! String
                                let sunrise = 0.00
                                let sunset = 0.00
                                self.weathersSystem.append(System(country: country, sunrise: sunrise, sunset: sunset))
                                
                                WeatherData.shared.parameters["country"] = country
                                WeatherData.shared.parameters["sunrise"] = 0.00
                                WeatherData.shared.parameters["sunset"] = 0.00
                           }
                            
                            var mainPictureUrl = "https://openweathermap.org/img/w/"
                            if let icon = WeatherData.shared.parameters["icon"] as? String {
                            
                                mainPictureUrl += icon + ".png"
                            }
                            if let checkedUrl = URL(string: mainPictureUrl) {
                                
                                self.imageMainWether.contentMode = .scaleAspectFit
                                self.downloadImageInView(url: checkedUrl)
                            }
                            DispatchQueue.main.async {
                                
                                if let temp = WeatherData.shared.parameters["temp"] as? Double {
                                    
                                    self.labelTemperature.text = String(lround(temp - 273.15))
                                }
                                if let country = WeatherData.shared.parameters["country"] as? String {
                                
                                    self.labelCountry.text = country
                                }
                            }
                        }
                            
                        else {
                            print("error data")
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                } else {
                    print("data is nil")
                }
            }
            
            task.resume()
            print("request is started")
        }
    }

    func loadDefault() {
        
        if let setCity = UserDefaults.standard.object(forKey: "cityName") as? String {
            
            textFieldCity.text = setCity
            setupUI()
            loadDataJsonAfterChangeDay(cityName: setCity, day: 0)
        }
    }
}
