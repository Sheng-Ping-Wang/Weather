//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Wang Sheng Ping on 2021/2/19.
//

import UIKit
import MapKit

protocol SendCityNameDelegate {
    func sendCityName(cityName: String)
}

class SearchViewController: UIViewController {

    

    
    //MARK: - Properties
    
    
    var fullSize = UIScreen.main.bounds.size
    var myTableview: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    var cities = ["Taipei", "Tainan", "Taoyuan", "London", "Tokyo", "United States"]
    var cityDelegate: SendCityNameDelegate?
    
    //MARK: - IBOutlets
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableview.backgroundColor = .black
        myTableview.delegate = self
        myTableview.dataSource = self
        setSearchContoller()
        addSubviews()
        setLayouts()
        


    }
    
    //MARK: - Functions
    
    func setSearchContoller(){
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.searchBarStyle = .default
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.searchTextField.textColor = .white
//        self.searchController.
        
        
        navigationItem.title = "Enter city, zip, or airport location"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.barTintColor = .black
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
//        tableView.tableHeaderView = searchController.searchBar
        
    }
    
    
    //MARK: - Add Subviews
    
    func addSubviews(){
        view.addSubview(myTableview)
    }
    
    //MARK: - Set Layouts

    func setLayouts(){
        
        myTableview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        myTableview.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        myTableview.widthAnchor.constraint(equalToConstant: fullSize.width).isActive = true
        myTableview.heightAnchor.constraint(equalToConstant: fullSize.height).isActive = true
        
    }

}

extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            print(searchText)
        }
    }
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        print(searchText)
//    }
}



//MARK: - UITableViewDelegate & UITableViewDataSource

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = cities[indexPath.row]
        cell.textLabel?.textColor = .red
        cell.backgroundColor = .black
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        cityDelegate?.sendCityName(cityName: cities[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
    
}

extension SearchViewController: MKLocalSearchCompleterDelegate{
 
    
    
}
