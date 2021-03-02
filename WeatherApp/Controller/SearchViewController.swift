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
    
    var searchView = SearchView()
    var fullSize = UIScreen.main.bounds.size
    var cities = [String]()
    var cityDelegate: SendCityNameDelegate?
    
    //MARK: - IBOutlets
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchView()
        setNavBar()
        addSubviews()
    }
    
    //MARK: - Functions
    
    func setSearchView() {
        searchView.myTableView.backgroundColor = .black
        searchView.myTableView.delegate = self
        searchView.myTableView.dataSource = self
        searchView.myTableView.keyboardDismissMode = .onDrag
        searchView.myTextField.delegate = self
        searchView.myTextField.becomeFirstResponder()
        searchView.addBtn.addTarget(self, action: #selector(addCity), for: .touchUpInside)
    }
    
    func setNavBar(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchView.addBtn)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchView.myTextField)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.barTintColor = .black
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    @objc func addCity() {
        if searchView.myTextField.text != ""{
            cityDelegate?.sendCityName(cityName: searchView.myTextField.text!)
        }
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Add Subviews
    
    func addSubviews(){
        view.addSubview(searchView.myTableView)
    }
    
    //MARK: - Set Layouts

}

//extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
//    func updateSearchResults(for searchController: UISearchController) {
//        if let searchText = searchController.searchBar.text {
//            print(searchText)
//        }
//    }
//}



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

//    MARK: DidSelect
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        cityDelegate?.sendCityName(cityName: cities[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchView.myTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
}
