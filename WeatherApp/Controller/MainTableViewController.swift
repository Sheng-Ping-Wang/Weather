//
//  ViewController.swift
//  WeatherApp
//
//  Created by Wang Sheng Ping on 2021/2/18.
//

import UIKit

let notificationKey = "getWeatherData"
class MainTableViewController: UITableViewController {

    //MARK: - Properties
    
    let mainPageView = MainPageView()
    var urlAddress = ""
    var cities = [String]() {
        didSet{
            saveCityData()
        }
    }
    var tempUnit : switchTempUnit = .c {
        didSet{
            tableView.reloadData()
        }
    }
    var weatherInfo = [WeatherData](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.saveData()
            }
        }
    }
    
    //MARK: - IBOutlets
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        addBtnAndLabelFunctions()
        loadData()
        loadCityData()
        NotificationCenter.default.addObserver(self, selector: #selector(getData(noti:)), name: Notification.Name(notificationKey), object: nil)
    }
    
    @objc func getData(noti: Notification) {

        if let weather = noti.userInfo?["weather"] as? WeatherData {
            weatherInfo.append(weather)
        }
    }
    
    //MARK: - Functions
    
    func setTableView() {
        tableView.rowHeight = 60
        tableView.separatorColor = .clear
        tableView.backgroundView = mainPageView
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
    }
    
    func addBtnAndLabelFunctions(){
        let myViewTouch = UITapGestureRecognizer(target: self, action: #selector(viewTouch))
        mainPageView.glassBtn.addTarget(self, action: #selector(popUpSearchVC), for: .touchUpInside)
        mainPageView.labelStackView.addGestureRecognizer(myViewTouch)
    }
    
    //轉場
    
    @objc func popUpSearchVC() {
        let searchVC = SearchViewController()
        searchVC.sendCityNameDelegate = self
        searchVC.deleteCityNamgeDelegate = self
        searchVC.cities = cities
        searchVC.weatherInfo = self.weatherInfo
        let nav = UINavigationController(rootViewController: searchVC)
        present(nav, animated: true, completion: nil)
    }
    
    //轉換溫度單位
    
    @objc func viewTouch() {
        if tempUnit == .c {
            mainPageView.celsiusLabel.textColor = .gray
            mainPageView.fahrenheitLabel.textColor = .white
            tempUnit = .f
        }else if tempUnit == .f {
            mainPageView.fahrenheitLabel.textColor = .gray
            mainPageView.celsiusLabel.textColor = .white
            tempUnit = .c
        }
    }

    //Save & Load Data
        
    func saveData() {
        UserDefaults.standard.set( try? PropertyListEncoder().encode(weatherInfo), forKey: ApiKeys.weatherKey)
        }
    
    func loadData() {
        if let data = UserDefaults.standard.value(forKey: ApiKeys.weatherKey) as? Data {
            let weather = try? PropertyListDecoder().decode(Array<WeatherData>.self, from: data)
            if let weather = weather {
                weatherInfo = weather
            }
        }
    }
        
    func saveCityData() {
        UserDefaults.standard.setValue(cities, forKey: ApiKeys.cityKey)
    }
    
    func loadCityData() {
        cities = UserDefaults.standard.stringArray(forKey: ApiKeys.cityKey) ?? []
    }
    
//    MARK: Convert Time
    
    func converTime(time: Double) -> String{
        let date = Date(timeIntervalSince1970: TimeInterval(time))
        let dateformatter = DateFormatter()
        dateformatter.timeStyle = .short
        let localTime = dateformatter.string(from: date as Date)
        return localTime
    }
    
//    MARK: Get Weather Png
    
    func getWeatherPng(png: String) -> Data{
        var imageData: Data!
        if let url = URL(string: "http://openweathermap.org/img/wn/\(png).png"){
            let data = try? Data(contentsOf: url)
            if let image = data {
                imageData = image
            }
        }
        return imageData
    }
    
    //MARK: - Add Subviews
    
    //MARK: - Set Layouts


}

//MARK: - UITableViewDelegate & UITableViewDataSource

extension MainTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherInfo.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
        let info = weatherInfo[indexPath.row]
        
        cell.cityLabel.text = info.name
        cell.timeLabel.text = converTime(time: Double(info.dt))
        if tempUnit == .c {
            cell.tempLabel.text = "\(info.main.temp.rounded())˚C"
        } else {
            cell.tempLabel.text = "\((info.main.temp * 9/5 + 32).rounded())˚F"
        }
        
        let image = getWeatherPng(png: info.weather[0].icon)
        cell.picView.image = UIImage(data: image)
        
        return cell
    }
    
//    MARK: - FooterView
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return mainPageView.footerView
    }
    
//    MARK: - DidSelect
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        detailVC.detailView.addBtn.isHidden = true
        detailVC.weatherInfo = weatherInfo[indexPath.row]
        detailVC.tempUnit = self.tempUnit
        detailVC.weatherInfo = self.weatherInfo[indexPath.row]
        present(detailVC, animated: true, completion: nil)
    }
    
//    MARK: - Delete
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            weatherInfo.remove(at: indexPath.row)
            let selectedIndex = IndexPath(row: indexPath.row, section: 0)
            tableView.deleteRows(at: [selectedIndex], with: .automatic)
        }
    }
}

//MARK: - Protocol

extension MainTableViewController: SendCityNameDelegate {
    func getCityName(cityName: String) {
        if cities.contains(cityName) {
            
        }else{
            cities.append(cityName)
        }
    }
}

extension MainTableViewController: DeleteCityNameDelegate {
    func deleteCityName(cityIndex: Int) {
        cities.remove(at: cityIndex)
    }
}

//extension MainTableViewController{
//
//    enum swichTempUnit: Int, CaseIterable {
//        case c, f
//    }
//}
