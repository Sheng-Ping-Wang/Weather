//
//  SearchTableViewCell.swift
//  WeatherApp
//
//  Created by Wang Sheng Ping on 2021/3/8.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    static let searchViewIdentifier = "searchIdentifierCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black
        textLabel?.textColor = .red
        selectionStyle = .none
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
