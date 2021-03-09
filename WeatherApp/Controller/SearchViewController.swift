//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Wang Sheng Ping on 2021/2/19.
//

import UIKit
import MapKit

protocol SendCityNameDelegate {
    func getCityName(cityName: String)
}

protocol DeleteCityNameDelegate {
    func deleteCityName(cityIndex: Int)
}

class SearchViewController: UIViewController {

    //MARK: - Properties
    
    var weatherInfo = [WeatherData]()
    var searchView = SearchView()
    var cities = [String]() {
        didSet{
            searchView.myTableView.reloadData()
        }
    }
    var sendCityNameDelegate: SendCityNameDelegate?
    var deleteCityNamgeDelegate: DeleteCityNameDelegate?
    
    //MARK: - IBOutlets
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = searchView
        setSearchView()
        setNavBar()
    }
    
    //MARK: - Functions
    
    func setSearchView() {
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
        if let text = searchView.myTextField.text?.trimmingCharacters(in: .whitespaces){
            checkRepeatCity(cityInfo: text)
            sendCityNameDelegate?.getCityName(cityName: text)
        }else{
            
        }
    }
    
//    MARK: 判斷是否影重複城市
    
    func checkRepeatCity(cityInfo: String) {
        
        let detailVC = DetailViewController()
        
        if weatherInfo.isEmpty {
            detailVC.cityInfo = cityInfo
            detailVC.detailView.addBtn.isHidden = false
        }else{
//            let name = weatherInfo.map({$0.name})
//            let id = "\(weatherInfo.map({$0.id}))"
//            //座標無法判斷,因為經緯度包在不同陣列
//            let coordinate = "\(weatherInfo.map({$0.coord.lon})), \(weatherInfo.map({$0.coord.lat}))"
//            print(name)
//            print(coordinate)
//            if name.contains(cityInfo) || id.contains(cityInfo) || coordinate.contains(cityInfo) {
//                detailVC.detailView.addBtn.isHidden = true
//                print("true")
//            }else{
//                detailVC.detailView.addBtn.isHidden = false
//                print("false")
//            }
            
            for i in 0...weatherInfo.count-1{
                if cityInfo == weatherInfo[i].name || cityInfo == String(weatherInfo[i].id) || cityInfo == "\(String(weatherInfo[i].coord.lon)), \( String(weatherInfo[i].coord.lat))" {
                    detailVC.detailView.addBtn.isHidden = true
                    break
                }else{
                    detailVC.detailView.addBtn.isHidden = false
                }
            }
        }
        detailVC.cityInfo = cityInfo
        present(detailVC, animated: true, completion: nil)
    }
    
    //MARK: - Add Subviews
    
    //MARK: - Set Layouts

}

//MARK: - UITableViewDelegate & UITableViewDataSource

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.searchViewIdentifier, for: indexPath) as! SearchTableViewCell
        cell.textLabel?.text = cities[indexPath.row]
        return cell
    }

//    MARK: DidSelect
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = cities[indexPath.row]
        checkRepeatCity(cityInfo: city)
    }
    
//    MARK: Delete
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cities.remove(at: indexPath.row)
            deleteCityNamgeDelegate?.deleteCityName(cityIndex: indexPath.row)
        }
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

//extension String {
//    func trimWhiteSpaces() -> String {
//        let whiteSpaceSet = NSCharacterSet.whitespaces
//        return self.trimmingCharacters(in: whiteSpaceSet)
//    }
//}
