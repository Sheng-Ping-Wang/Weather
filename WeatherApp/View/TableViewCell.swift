//
//  TableViewCell.swift
//  WeatherApp
//
//  Created by Wang Sheng Ping on 2021/2/19.
//

import UIKit

class TableViewCell: UITableViewCell{

    //MARK: - Properties
    
    static let identifier = "cell"
    let fullSize = UIScreen.main.bounds.size
    
    //MARK: - IBOutlets
    
    var picView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont(name: "Arial Bold", size: 15)
        return label
    }()
    
    var cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont(name: "Arial Bold", size: 22)
        return label
    }()
    
    var tempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.textColor = .white
        label.font = UIFont(name: "Arial Bold", size: 35)
        return label
    }()
    
    
    //MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Functions
    

    
    //MARK: - Add Subviews
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(picView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(cityLabel)
        contentView.addSubview(tempLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Set Layouts
    
    override func layoutSubviews() {
        
        picView.rightAnchor.constraint(equalTo: tempLabel.leftAnchor).isActive = true
        picView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        picView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        picView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        timeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: +10).isActive = true
        timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: +10).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        cityLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: +10).isActive = true
        cityLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor).isActive = true
        cityLabel.widthAnchor.constraint(equalToConstant: 350).isActive = true
        cityLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        tempLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        tempLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        tempLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        tempLabel.heightAnchor.constraint(equalToConstant: fullSize.height).isActive = true
        

        
    }
    
    
    


}
