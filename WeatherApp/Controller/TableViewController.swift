//
//  ViewController.swift
//  WeatherApp
//
//  Created by Wang Sheng Ping on 2021/2/18.
//

import UIKit

class TableViewController: UITableViewController {

    //MARK: - Properties
    
    var fullSize = UIScreen.main.bounds.size
    let mainPageView = MainPageView()
    var cities = [String]()
    var urlAddress = ""
    var tempUnit : swichTempUnit = .c {
        didSet{
            tableView.reloadData()
        }
    }
    var weatherInfo = [WeatherData](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - IBOutlets
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 60
        tableView.separatorColor = .clear
        tableView.backgroundView = mainPageView
        addBtnAndLabelFunctions()
    }
    
    //MARK: - Functions
    
    func addBtnAndLabelFunctions(){
        let myViewTouch = UITapGestureRecognizer(target: self, action: #selector(viewTouch))
        mainPageView.glassBtn.addTarget(self, action: #selector(popUpSearchVC), for: .touchUpInside)
        mainPageView.labelStackView.addGestureRecognizer(myViewTouch)
    }
    
    func getWeatherData() {
        if let url = URL(string: urlAddress.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else if let response = response as? HTTPURLResponse,let data = data {
                    print("Status code: \(response.statusCode)")
                    let decoder = JSONDecoder()
                    if let weatherData = try?
                        decoder.decode(WeatherData.self, from: data) {
                        self.weatherInfo.append(weatherData)
                        print(self.weatherInfo)
                        print("============== Weather data ==============")
                        print("城市名稱：\(weatherData.name)")
                        print("經緯度：\(weatherData.coord.lon), \(weatherData.coord.lat)")
                        print("溫度：\(weatherData.main.temp)")
                        print("描述：\(weatherData.weather[0].weatherDescription)")
                        print("Unix Time: \(weatherData.dt)")
                        print("============== Weather data ==============")
                    }
                }
                }.resume()
        } else {
            print("Invalid URL.")
        }
    }
    
    //轉場
    
    @objc func popUpSearchVC() {
        let searchVC = SearchViewController()
        searchVC.cityDelegate = self
        searchVC.cities = cities
        let nav = UINavigationController(rootViewController: searchVC)
        present(nav, animated: true, completion: nil)
    }
    
    //轉換溫度單位
    
    @objc func viewTouch() {
        
        if tempUnit == .c {
            mainPageView.celsiusLabel.textColor = .gray
            mainPageView.fahrenheitLabel.textColor = .white
            for i in 0..<weatherInfo.count
            {
                weatherInfo[i].main.temp = weatherInfo[i].main.temp * 9 / 5 + 32.0
            }
            tempUnit = .f
        }else if tempUnit == .f {
            mainPageView.fahrenheitLabel.textColor = .gray
            mainPageView.celsiusLabel.textColor = .white
            tempUnit = .c
            for i in 0..<weatherInfo.count
            {
                weatherInfo[i].main.temp = (weatherInfo[i].main.temp - 32.0) * 5 / 9
            }
        }
    }

    //MARK: - Add Subviews
    
    //MARK: - Set Layouts


}

//MARK: - UITableViewDelegate & UITableViewDataSource

extension TableViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherInfo.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        let info = weatherInfo[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        cell.cityLabel.text = info.name
        
        if tempUnit == .c {
            cell.tempLabel.text = "\(info.main.temp.rounded())˚C"
        } else {
            cell.tempLabel.text = "\(info.main.temp.rounded())˚F"
        }
        

        let date = Date(timeIntervalSince1970: TimeInterval(info.dt))
        let dateformatter = DateFormatter()
        dateformatter.timeStyle = .short
        let localTime = dateformatter.string(from: date as Date)
        cell.timeLabel.text = "\(localTime)"
        
        if let url = URL(string: "http://openweathermap.org/img/wn/\(info.weather[0].icon).png"){
            let data = try? Data(contentsOf: url)

            if let image = data {
                cell.picView.image = UIImage(data: image)
            }
        }
        
        return cell
    }
    
//    MARK: - FooterView
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return mainPageView.footerView
    }
    
//    MARK: - DidSelect
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        detailVC.transitioningDelegate = self
        detailVC.detailView.cityLabel.text = weatherInfo[indexPath.row].name
        if tempUnit == .c {
            detailVC.detailView.tempLabel.text = "\(weatherInfo[indexPath.row].main.temp.rounded())˚C"
        }else{
            detailVC.detailView.tempLabel.text = "\(weatherInfo[indexPath.row].main.temp.rounded())˚F"
        }
        detailVC.weatherInfo = self.weatherInfo[indexPath.row]
        present(detailVC, animated: true, completion: nil)
    }
    
//    MARK: - Delete
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            weatherInfo.remove(at: indexPath.row)
        }
    }

}

extension TableViewController: SendCityNameDelegate{
    func sendCityName(cityName: String) {
        if cityName.contains(",") {
            let cityCoordinate = cityName.components(separatedBy: ", ")
            if let longitude = Double(cityCoordinate[0]), let latitude = Double(cityCoordinate[1]){
            urlAddress = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=metric&appid=\(ApiKeys.apiKey)"
            }
        }else if let cityID = Int(cityName){
            urlAddress = "https://api.openweathermap.org/data/2.5/weather?id=\(cityID)&units=metric&appid=\(ApiKeys.apiKey)"
        }else{
            urlAddress = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&units=metric&appid=\(ApiKeys.apiKey)"
        }
        
        if cities.contains(cityName){
        }else{
            cities.append(cityName)
        }
        getWeatherData()
    }
}

//MARK: - Animation

extension TableViewController: UIViewControllerTransitioningDelegate{
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
}

extension TableViewController{
    
    enum swichTempUnit: Int, CaseIterable {
        case c, f
    }
    
}
