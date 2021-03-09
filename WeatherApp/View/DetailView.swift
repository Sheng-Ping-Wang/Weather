//
//  DetailView.swift
//  WeatherApp
//
//  Created by Wang Sheng Ping on 2021/2/24.
//

import UIKit

class DetailView: UIView {

    //MARK: - Properties
    
    let fullSize = UIScreen.main.bounds.size
    
    //MARK: - IBOutlets
    
    let addBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.isHidden = true
        return button
    }()
    
    var cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Arial Bold", size: 30)
        return label
    }()
    
    var tempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 50)
        return label
    }()
    
    var myTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.detailCellIdentifier)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 60
        return tableView
    }()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(cityLabel)
        addSubview(tempLabel)
        addSubview(myTableView)
        addSubview(addBtn)
        setGradientLayer()
        
        cityLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        cityLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: +50).isActive = true
        cityLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        cityLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        tempLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        tempLabel.topAnchor.constraint(equalTo: cityLabel.topAnchor, constant: +40).isActive = true
        tempLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        tempLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        myTableView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        myTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        myTableView.widthAnchor.constraint(equalToConstant: fullSize.width).isActive = true
        myTableView.heightAnchor.constraint(equalToConstant: fullSize.height * 2/3).isActive = true
        
        addBtn.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        addBtn.topAnchor.constraint(equalTo: self.topAnchor, constant: +10).isActive = true
//        addBtn.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        addBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    
    func setGradientLayer() {
        let color1 = UIColor.systemBlue.cgColor
        let color2 = UIColor.systemGreen.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame(forAlignmentRect: CGRect(x: 0, y: 0, width: fullSize.width, height: fullSize.height))
        gradientLayer.colors = [color2, color1]
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    //MARK: - Add Subviews
    
    //MARK: - Set Layouts


}
