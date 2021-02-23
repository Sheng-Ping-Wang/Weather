//
//  FooterVIew.swift
//  WeatherApp
//
//  Created by Wang Sheng Ping on 2021/2/22.
//

import UIKit

class FooterVIew: UIView {

    var celsiusLabel: UILabel = {
    let label = UILabel()
    label.text = "˚C"
    label.textColor = .white
    return label
    }()
    
    var slashLabel: UILabel = {
    let label = UILabel()
    label.text = " /"
    label.textColor = .gray
    return label
    }()
    
    var fahrenheitLabel: UILabel = {
    let label = UILabel()
    label.text = " ˚F"
    label.textColor = .gray
    return label
    }()
    
    var glassBtn: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("\u{1F50D}", for: .normal)
    return button
    }()
    
    lazy var myStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [celsiusLabel,slashLabel, fahrenheitLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
       return stackView
    }()
    
//    MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .brown
        addSubview(glassBtn)
        addSubview(myStackView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
