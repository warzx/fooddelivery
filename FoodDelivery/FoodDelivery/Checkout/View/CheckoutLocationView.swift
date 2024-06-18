//
//  CheckoutLocationView.swift
//  FoodDelivery
//
//  Created by William on 18/6/24.
//

import UIKit

protocol CheckoutLocationViewDelegate: AnyObject {
    func onSetLocationButtonDidTapped()
}

class CheckoutLocationView: UIView {
    weak var delegate: CheckoutLocationViewDelegate?
    
    private lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 24.0, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Delivery Location"
        return label
    }()
    
    private lazy var savedLocationLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Not yet set"
        return label
    }()
    
    private lazy var locationDetailsLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        return label
    }()
    
    private lazy var setLocationButton: UIButton = {
        let button: UIButton = UIButton(frame: .zero)
        button.tintColor = .systemOrange
        var config = UIButton.Configuration.borderedTinted()
        config.image = UIImage(systemName: "mappin.and.ellipse")
        config.title = "Set Location"
        config.buttonSize = .medium
        config.cornerStyle = .capsule
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(setLocationButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLocation(locationName: String, locationDetails: String) {
        savedLocationLabel.text = locationName
        locationDetailsLabel.text = locationDetails
    }
}

private extension CheckoutLocationView {
    func setupView() {
        addSubview(titleLabel)
        addSubview(savedLocationLabel)
        addSubview(locationDetailsLabel)
        addSubview(setLocationButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.0),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            
            savedLocationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0),
            savedLocationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            savedLocationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            
            locationDetailsLabel.topAnchor.constraint(equalTo: savedLocationLabel.bottomAnchor, constant: 4.0),
            locationDetailsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            locationDetailsLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.0),
            locationDetailsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            
            setLocationButton.topAnchor.constraint(equalTo: topAnchor, constant: 16.0),
            setLocationButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            setLocationButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16.0)
        ])
    }
    
    @objc
    func setLocationButtonDidTapped() {
        delegate?.onSetLocationButtonDidTapped()
    }
}
