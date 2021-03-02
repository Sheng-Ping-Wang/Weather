//
//  FooterVIew.swift
//  WeatherApp
//
//  Created by Wang Sheng Ping on 2021/2/22.
//

import UIKit

class MainPageView: UIView {

    var fullSize = UIScreen.main.bounds.size
    
    var footerView: UIView = {
    let view = UIView()
    return view
    }()
    
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
    
    lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [celsiusLabel,slashLabel, fahrenheitLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
       return stackView
    }()
    
//    MARK: - Functions
    
    func setGradientLayer() {
        let color1 = UIColor.systemBlue.cgColor
        let color2 = UIColor.systemGreen.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame(forAlignmentRect: CGRect(x: 0, y: 0, width: fullSize.width, height: fullSize.height))
        gradientLayer.colors = [color1, color2]
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
//    MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setGradientLayer()
        footerView.addSubview(glassBtn)
        footerView.addSubview(labelStackView)
        
//        MARK: Layouts
        glassBtn.rightAnchor.constraint(equalTo: footerView.rightAnchor, constant: -10).isActive = true
        glassBtn.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        
        labelStackView.leftAnchor.constraint(equalTo: footerView.leftAnchor, constant: +10).isActive = true
        labelStackView.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
}
