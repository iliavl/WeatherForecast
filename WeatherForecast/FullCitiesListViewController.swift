//
//  DateVC.swift
//  WeatherForecast
//
//  Created by LIV on 14.07.17.
//  Copyright © 2017 LIV. All rights reserved.
//

import UIKit
import RealmSwift

protocol FullCitiesListViewControllerDelegate {
    
    func fillTheTextFieldCity(description: String)
}

class FullCitiesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate {

    let searchController = UISearchController(searchResultsController: nil)
    var delegate: FullCitiesListViewControllerDelegate?
    var citiesArray = [CitiesFCL]()
    var filteredCitiesArray = [CitiesFCL]()
    
    @IBOutlet weak var tblWFullCitiesList: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
 
        //self.automaticallyAdjustsScrollViewInsets = false
        tblWFullCitiesList.delegate = self as? UITableViewDelegate
        tblWFullCitiesList.dataSource = self
        realmLoadFromDBFullCities()
        filteredCitiesArray = citiesArray
        setUI()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblWFullCitiesList.dequeueReusableCell(withIdentifier: "FullCityListTableViewCell", for: indexPath) as! FullCityListTableViewCell
        
        if searchController.isActive {
            
            cell.configureDate(city: filteredCitiesArray[indexPath.row].city)
            
        } else {
            
            cell.configureDate(city: citiesArray[indexPath.row].city)
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
        
        let cell = tblWFullCitiesList.cellForRow(at: indexPath) as? FullCityListTableViewCell
        let description = cell?.labelCityCell.text
        delegate?.fillTheTextFieldCity(description: description!)
        searchController.isActive = false
        let _ = navigationController?.popViewController(animated: true)
    }
    
    private func realmLoadFromDBFullCities() {
        
        do {
            let realm = try Realm()
            let cities = realm.objects(FullCitiesList.self)
            let citiesSorted = cities.sorted(byKeyPath: "name")
            
            for city in citiesSorted {
                
                 let name = city.name
                    self.citiesArray.append(CitiesFCL(city: name))
                    print("reading from DB /name/ \(name)")
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
    }

    private func setUI() {
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        tblWFullCitiesList.tableHeaderView = searchController.searchBar
        self.automaticallyAdjustsScrollViewInsets = false
    }

}

extension FullCitiesListViewController: UISearchResultsUpdating {
    
    @available(iOS 8.0, *)
    
    func updateSearchResults(for searchController: UISearchController) {
        
        print(searchController.searchBar.text ?? "empty")
        
        if searchController.searchBar.text != "" {
            
            filteredCitiesArray = citiesArray.filter({ (cityElem) -> Bool in
                
                return cityElem.city.lowercased().contains((searchController.searchBar.text?.lowercased())!)
            })
            
            print(filteredCitiesArray)
            tblWFullCitiesList.reloadSections([0], with: .fade)
        } else {
            
            filteredCitiesArray = citiesArray
            tblWFullCitiesList.reloadSections([0], with: .fade)
        }
    }
}

