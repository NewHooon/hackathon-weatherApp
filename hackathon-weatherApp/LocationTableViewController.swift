//
//  LocationTableViewController.swift
//  hackathon-weatherApp
//
//  Created by sehooon on 2022/10/10.
//

import UIKit

class LocationTableViewController: UITableViewController {

    @IBOutlet weak var locationSearchBar: UISearchBar!
    
    var dataSendClosure: ((_ data: String) -> Void)?
    var locationDB = LocationDB()
    var filterData:[LocationModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        locationDB.LocationInfoFromCSV()
        locationSearchBar.delegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return filterData.count }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(filterData[indexPath.row].firstDivision + filterData[indexPath.row].secondDivision + filterData[indexPath.row].thirdDivision)
        print(filterData[indexPath.row].nx)
        print(filterData[indexPath.row].ny)
        sendWeatherData(filterData[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.text = filterData[indexPath.row].firstDivision + " " + filterData[indexPath.row].secondDivision +  " " +  filterData[indexPath.row].thirdDivision
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{ filterData = locationDB.locationDataArr}else{
            filterData.removeAll()
            for location in locationDB.locationDataArr {
                let lString = location.firstDivision + " " + location.secondDivision + " " + location.thirdDivision
                if lString.contains(searchText){ filterData.append(location) }
            }
        }
        self.tableView.reloadData()
    }
    
    //
    func sendWeatherData(_ locationItem: LocationModel){
        guard let mainVC = storyboard?.instantiateViewController(withIdentifier: "mainVC") as? MainViewController else{ return }
        mainVC.weatherAPI.requestWeatherData(nx: locationItem.nx, ny: locationItem.ny)
        self.dataSendClosure?(locationItem.dataKey)
        dismiss(animated: true, completion: nil)
    }
}

extension LocationTableViewController: UISearchBarDelegate{ }
