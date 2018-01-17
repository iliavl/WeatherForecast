//
//  CitiesListViewController.swift
//  WeatherForecast
//
//  Created by LIV on 10.07.17.
//  Copyright © 2017 LIV. All rights reserved.
//
import UIKit
import CoreData
import RealmSwift

protocol CityListViewControllerDelegate {
    
    func fillTheTextFieldCity(description: String)
}

class CitiesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {

    let searchController = UISearchController(searchResultsController: nil)
    var delegate: CityListViewControllerDelegate?
    var citiesArray = [Cities]()
    var filteredCitiesArray = [Cities]()
    
    @IBOutlet weak var tableViewCity: UITableView!
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableViewCity.delegate = self as? UITableViewDelegate
        tableViewCity.dataSource = self
        realmLoadFromDBFav()
        filteredCitiesArray = citiesArray
        setUI()
    }

    func loadDataJson() {
        
        do {
            if let file = Bundle.main.url(forResource: "citylistUA", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [[String: Any]] {
                    // json is a dictionary
                    
                    //if let namesArray = object["name"] as? [[String: Any]] {
                        
                        for name in object {
                            
                            let nameString = name["name"] as! String
                            self.citiesArray.append(Cities(city: nameString))
                        }
                    //}
                    DispatchQueue.main.async {
                        self.tableViewCity.reloadData()
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
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableViewCity.dequeueReusableCell(withIdentifier: "CitiyTableViewCell", for: indexPath) as! CitiyTableViewCell
        
        if searchController.isActive {
            
            cell.configure(description: filteredCitiesArray[indexPath.row].city)
            
        } else {
            
            cell.configure(description: citiesArray[indexPath.row].city)
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive {
            
            return filteredCitiesArray.count
        } else {
            
            return citiesArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableViewCity.cellForRow(at: indexPath) as? CitiyTableViewCell
        let description = cell?.labelCityCell.text
        delegate?.fillTheTextFieldCity(description: description!)
        searchController.isActive = false
        let _ = navigationController?.popViewController(animated: true)
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
                        
                        self.citiesArray.append(Cities(city: name))
                        print("reading from DB /name/ \(name)")
                    }
                }
            }
            
        } catch {
            
            print(error)
        }
    }
    
    private func realmLoadFromDBFav() {
        
        do {
            let realm = try Realm()
            let cities = realm.objects(City.self).mutableArrayValue(forKey: "name")
            
            for city in cities {
                
                if let name = city as? String {
                self.citiesArray.append(Cities(city: name))
                print("reading from DB /name/ \(name)")
                }
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func setUI() {
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        tableViewCity.tableHeaderView = searchController.searchBar
        self.automaticallyAdjustsScrollViewInsets = false
    }
}

extension CitiesListViewController: UISearchResultsUpdating {
        
        @available(iOS 8.0, *)
        
        func updateSearchResults(for searchController: UISearchController) {
            
            print(searchController.searchBar.text ?? "empty")
            
            if searchController.searchBar.text != "" {
                
                filteredCitiesArray = citiesArray.filter({ (cityElem) -> Bool in
                    
                        return cityElem.city.lowercased().contains((searchController.searchBar.text?.lowercased())!)
                    })
                
                print(filteredCitiesArray)
                tableViewCity.reloadSections([0], with: .fade)
            } else {
                
                filteredCitiesArray = citiesArray
                tableViewCity.reloadSections([0], with: .fade)
            }
        }
    }
