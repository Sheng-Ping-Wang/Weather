//
//  DetailTableViewCell.swift
//  WeatherApp
//
//  Created by Wang Sheng Ping on 2021/2/24.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    static let detailCellIdentifier = "detailCell"
    var fullSize = UIScreen.main.bounds.size
    
    //MARK: - IBOutlets
    
    var leftLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "SUNRISE"
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 15)
        return label
    }()
    
    var leftInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 30)
        return label
    }()
    
    lazy var leftLabelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [leftLabel, leftInfoLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        return stackView
    }()
    
    var rightLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 15)
        return label
    }()
    
    var rightInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 30)
        return label
    }()
    
    lazy var rightLabelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [rightLabel, rightInfoLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        return stackView
    }()
    
    //MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        contentView.addSubview(sunriseLabel)
//        contentView.addSubview(sunsetLabel)
        contentView.addSubview(leftLabelStackView)
        contentView.addSubview(rightLabelStackView)
        backgroundColor = .clear
        selectionStyle = .none
        
        NSLayoutConstraint.activate([
            leftLabelStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: +10),
            leftLabelStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: +10),
            leftLabelStackView.widthAnchor.constraint(equalToConstant: 200),
            leftLabelStackView.heightAnchor.constraint(equalToConstant: 60),
            
            rightLabelStackView.leftAnchor.constraint(equalTo: leftLabelStackView.rightAnchor, constant: +20),
            rightLabelStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: +10),
            rightLabelStackView.widthAnchor.constraint(equalToConstant: 200),
            rightLabelStackView.heightAnchor.constraint(equalToConstant: 60),
        ])
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    
    //MARK: - Add Subviews
    
    //MARK: - Set Layouts


}
