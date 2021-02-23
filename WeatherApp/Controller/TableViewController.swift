//
//  ViewController.swift
//  WeatherApp
//
//  Created by Wang Sheng Ping on 2021/2/18.
//

import UIKit

class TableViewController: UITableViewController {

    //MARK: - Properties
//    var tempChanged: [tempChamged] = [.c, .f]
    var fullSize = UIScreen.main.bounds.size
    var weatherInfo = [WeatherData]()
    let footerView = FooterVIew()
//    var selectedCell = UITableViewCell?
    //MARK: - IBOutlets
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 60
        tableView.separatorColor = .clear
        view.backgroundColor = .brown
        setLayouts()
        addBtnAndLabelFunctions()
    }
    
    //MARK: - Functions
    
    func addBtnAndLabelFunctions(){
        let myViewTouch = UITapGestureRecognizer(target: self, action: #selector(viewTouch))
        footerView.glassBtn.addTarget(self, action: #selector(popUpSearchVC), for: .touchUpInside)
        footerView.myStackView.addGestureRecognizer(myViewTouch)
    }
    
    func getWeatherData(city: String) {
        let address = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&units=metric&appid=\(ApiKeys.apiKey)"
        if let url = URL(string: address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
            // GET
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                // 假如錯誤存在，則印出錯誤訊息（ 例如：網路斷線等等... ）
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                  // 取得 response 和 data
                } else if let response = response as? HTTPURLResponse,let data = data {
                    // 將 response 轉乘 HTTPURLResponse 可以查看 statusCode 檢查錯誤（ ex: 404 可能是網址錯誤等等... ）
                    print("Status code: \(response.statusCode)")
                    // 創建 JSONDecoder 實例來解析我們的 json 檔
                    let decoder = JSONDecoder()
                    // decode 從 json 解碼，返回一個指定類型的值，這個類型必須符合 Decodable 協議
                    if let weatherData = try? decoder.decode(WeatherData.self, from: data) {
                        self.weatherInfo.append(weatherData)
                        
                        print(self.weatherInfo)
                        print("============== Weather data ==============")
                        print("城市名稱：\(weatherData.name)")
                        print("經緯度：\(weatherData.coord.lon), \(weatherData.coord.lat)")
                        print("溫度：\(weatherData.main.temp)")
                        print("描述：\(weatherData.weather[0].weatherDescription)")
                        print("============== Weather data ==============")
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
                }.resume()
        } else {
            print("Invalid URL.")
        }
    }
    
    @objc func popUpSearchVC() {
        let searchVC = SearchViewController()
        searchVC.cityDelegate = self
        let nav = UINavigationController(rootViewController: searchVC)
        present(nav, animated: true, completion: nil)
    }
    
    @objc func viewTouch() {
        if footerView.celsiusLabel.textColor == UIColor.white{
            footerView.celsiusLabel.textColor = .gray
            footerView.fahrenheitLabel.textColor = .white
            
            for i in 0..<weatherInfo.count
            {
                weatherInfo[i].main.temp = weatherInfo[i].main.temp * 9 / 5 + 32.0
                
            }
            tableView.reloadData()
            
        }else{
            footerView.celsiusLabel.textColor = .white
            footerView.fahrenheitLabel.textColor = .gray
            
//            let numberInfo = weatherInfo.map({$0.main.temp * 9/5 + 32})
//            weatherInfo.map({$0.main.temp}) = numberInfo
            
            for i in 0..<weatherInfo.count
            {
                weatherInfo[i].main.temp = (weatherInfo[i].main.temp - 32.0) * 5/9
            }
            tableView.reloadData()
            
        }
    }

    
    //MARK: - Add Subviews
    
    //MARK: - Set Layouts

    func setLayouts() {
        
        footerView.glassBtn.rightAnchor.constraint(equalTo: footerView.rightAnchor, constant: -10).isActive = true
        footerView.glassBtn.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        
        footerView.myStackView.leftAnchor.constraint(equalTo: footerView.leftAnchor, constant: +10).isActive = true
        footerView.myStackView.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        
    }

}

//MARK: - UITableViewDelegate & UITableViewDataSource

extension TableViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherInfo.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
        cell.cityLabel.text = weatherInfo[indexPath.row].name
        
        cell.tempLabel.text = "\(weatherInfo[indexPath.row].main.temp.rounded())˚C"

        cell.timeLabel.text = "\(weatherInfo[indexPath.row].timezone)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "\u{1F50D}"
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let detailVC = DetailViewController()
//        detailVC.transitioningDelegate = self
//        selectedCell = tableView.cellForRow(at: indexPath) as? UITableViewCell
//    }


    
}

extension TableViewController: SendCityNameDelegate{
    func sendCityName(cityName: String) {
        getWeatherData(city: cityName)
        tableView.reloadData()
    }
}

//extension TableViewController {
//
//    enum tempChamged: CaseIterable {
//        case c, f
//        static var currentUnit = c
//    }
//}

//MARK: - Animation

extension TableViewController: UIViewControllerTransitioningDelegate{
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
}
