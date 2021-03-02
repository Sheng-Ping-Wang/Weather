//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Wang Sheng Ping on 2021/2/23.
//

import UIKit

class DetailViewController: UIViewController {

    //MARK: - Properties
    
    let detailView = DetailView()
    var weatherInfo: WeatherData!
    let leftArr = ["SUNRISE", "TEMPMAX", "PRESSURE"]
    let rightArr = ["SUNSET", "TEMPMIN", "HUMIDITY"]
    lazy var leftInfo = ["\(String(describing: weatherInfo.main.tempMax))˚", "\(String(describing: weatherInfo.main.pressure)) hPa"]
    lazy var rightInfo = ["\(String(describing: weatherInfo.main.tempMin))˚", "\(String(describing: weatherInfo.main.humidity))%"]
    
    //MARK: - IBOutlets
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = detailView
        detailView.myTableView.delegate = self
        detailView.myTableView.dataSource = self
        convertTime()
    }
    
    //MARK: - Functions
    
    func convertTime() {
        let sunrise = Date(timeIntervalSince1970: TimeInterval((weatherInfo!.sys.sunrise)))
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
    
    //MARK: - Add Subviews
    
    //MARK: - Set Layouts

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
