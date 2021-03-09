//
//  SearchView.swift
//  WeatherApp
//
//  Created by Wang Sheng Ping on 2021/2/24.
//

import UIKit

class SearchView: UIView {

    //MARK: - Properties
    
    var fullSize = UIScreen.main.bounds.size
    
    //MARK: - IBOutlets
    
    lazy var myTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.searchViewIdentifier)
        tableView.backgroundColor = .black
        return tableView
    }()

    var myTextField: UITextField = {
       let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Enter city, city ID, or x, y", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.textColor = .white
        textField.backgroundColor = .black
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 5
        textField.frame = CGRect(x: 0, y: 0, width: 300, height: 30)
        return textField
    }()
    
    var addBtn: UIButton = {
       let button = UIButton()
        button.setTitle("Search", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.blue, for: .highlighted)
        button.backgroundColor = .systemBlue
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 5
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        return button
    }()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(myTableView)
        addSubview(myTextField)
        addSubview(addBtn)
        
        myTableView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        myTableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        myTableView.widthAnchor.constraint(equalToConstant: fullSize.width).isActive = true
        myTableView.heightAnchor.constraint(equalToConstant: fullSize.height).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Functions
    
    //MARK: - Add Subviews
    
    //MARK: - Set Layouts


}
