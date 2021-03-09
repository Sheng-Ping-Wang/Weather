//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Wang Sheng Ping on 2021/2/23.
//

import UIKit

class DetailViewController: UIViewController {

    //MARK: - Properties
    
    var tempUnit: switchTempUnit = .c
    let detailView = DetailView()
    var weatherInfo: WeatherData? {
        didSet{
            setArrsAndLabels()
            convertTime()
            self.detailView.myTableView.reloadData()
        }
    }
    var cityInfo: String?
    var urlAddress = ""
    //用struct包及用init
    let leftArr = ["SUNRISE", "TEMPMAX", "PRESSURE"]
    let rightArr = ["SUNSET", "TEMPMIN", "HUMIDITY"]
    var leftInfo = ["-", "-", "-"]
    var rightInfo = ["-", "-", "-"]
    
    //MARK: - IBOutlets
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = detailView
        detailView.myTableView.delegate = self
        detailView.myTableView.dataSource = self
//        getCityUrl()
        getWeatherData()
        addBtnFunc()
    }
    

    //MARK: - Functions
    
    func addBtnFunc() {
        detailView.addBtn.addTarget(self, action: #selector(addCity), for: .touchUpInside)
    }
    
    @objc func addCity() {
        let info = ["weather" : weatherInfo]
        NotificationCenter.default.post(name: Notification.Name(notificationKey), object: self, userInfo: info as [AnyHashable : Any])
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func convertTime() {
        if let weatherInfo = weatherInfo {
        let sunrise = Date(timeIntervalSince1970: TimeInterval((weatherInfo.sys.sunrise)))
        let sunriseDateformatter = DateFormatter()
        sunriseDateformatter.timeStyle = .short
        let sunriseTime = sunriseDateformatter.string(from: sunrise as Date)
        leftInfo.insert(sunriseTime, at: 0)
        
        let sunset = Date(timeIntervalSince1970: TimeInterval((weatherInfo.sys.sunset)))
        let sunsetDateformatter = DateFormatter()
        sunsetDateformatter.timeStyle = .short
        let sunsetTime = sunsetDateformatter.string(from: sunset as Date)
        rightInfo.insert(sunsetTime, at: 0)
        }
    }
    
    func setArrsAndLabels() {
        if tempUnit == .c{
            if let weatherInfo = weatherInfo{
            self.leftInfo = ["\(weatherInfo.main.tempMax)˚C", "\(weatherInfo.main.pressure)"]
            self.rightInfo = ["\(weatherInfo.main.tempMin)˚C", "\(weatherInfo.main.humidity)"]
            detailView.cityLabel.text = weatherInfo.name
            detailView.tempLabel.text = "\(weatherInfo.main.temp.rounded())˚C"
            }
        }else{
            if let weatherInfo = weatherInfo{
                self.leftInfo = ["\((weatherInfo.main.tempMax * 9/5 + 32).rounded())˚F", "\(weatherInfo.main.pressure)"]
                self.rightInfo = ["\((weatherInfo.main.tempMin * 9/5 + 32).rounded())˚F", "\(weatherInfo.main.humidity)"]
            detailView.cityLabel.text = weatherInfo.name
            detailView.tempLabel.text = "\((weatherInfo.main.temp * 9/5 + 32).rounded())˚F"
            }
        }

    }
    
    func getWeatherData() {
        var urlComponent = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather?")
        urlComponent?.queryItems = getCityUrl()
        
        if let url = URL(string: urlComponent?.url?.absoluteString ?? "") {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }else if let response = response as? HTTPURLResponse,let data = data {
                DispatchQueue.main.async {
                    if response.statusCode != 200 {
                        print("City not found")
                        self.detailView.cityLabel.text = "City Not Found"
                        self.detailView.addBtn.isHidden = true
                    }
                }
                print("Status code: \(response.statusCode)")
                let decoder = JSONDecoder()
                if let weatherData = try?
                    decoder.decode(WeatherData.self, from: data) {
                    DispatchQueue.main.async {
                        self.weatherInfo = weatherData
                    }
                    print("============== Weather data ==============")
                    print("城市名稱：\(weatherData.name)")
                    print("經緯度：\(weatherData.coord.lon), \(weatherData.coord.lat)")
                    print("溫度：\(weatherData.main.temp)")
                    print("描述：\(weatherData.weather[0].weatherDescription)")
                    print("Unix Time: \(weatherData.dt)")
                    print("Id: \(weatherData.id)")
                    print("============== Weather data ==============")
                    }
                }
                }.resume()
        } else {
            print("Invalid URL.")
        }
    }
    
    func getCityUrl() -> [URLQueryItem] {
        var urlAddress = [URLQueryItem]()
        if let cityInfo = cityInfo {
        
            if cityInfo.contains(",") {
                let cityCoordinate = cityInfo.components(separatedBy: ", ")
                urlAddress.append(URLQueryItem(name: "lat", value: "\(cityCoordinate[1])"))
                urlAddress.append(URLQueryItem(name: "lon", value: "\(cityCoordinate[0])"))
            }else if let cityID = Int(cityInfo) {
                urlAddress.append(URLQueryItem(name: "id", value: "\(String(describing: cityID))"))
            }else{
                urlAddress.append(URLQueryItem(name: "q", value: "\(cityInfo)"))
            }
            urlAddress.append(URLQueryItem(name: "units", value: "metric"))
            urlAddress.append(URLQueryItem(name: "appid", value: "\(ApiKeys.apiKey)"))
        }
        return urlAddress
    }

}

//MARK: - UITableViewDataSource & UITableViewDelegate

extension DetailViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        leftArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.detailCellIdentifier, for: indexPath) as! DetailTableViewCell

        cell.leftLabel.text = leftArr[indexPath.row]
        cell.leftInfoLabel.text = leftInfo[indexPath.row]
        cell.rightLabel.text = rightArr[indexPath.row]
        cell.rightInfoLabel.text = rightInfo[indexPath.row]
        return cell
    }
    
}

