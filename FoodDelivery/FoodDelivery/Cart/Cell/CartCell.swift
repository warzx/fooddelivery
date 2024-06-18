//
//  CartCell.swift
//  FoodDelivery
//
//  Created by William on 18/6/24.
//

import UIKit

class CartCell: UITableViewCell {
    private lazy var restaurantNameLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var totalItemLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCellModel(cellModel: CartCellModel) {
        restaurantNameLabel.text = cellModel.restaurantName
        totalItemLabel.text = cellModel.totalItem
    }
}

private extension CartCell {
    func setupView() {
        contentView.addSubview(restaurantNameLabel)
        contentView.addSubview(totalItemLabel)
        
        NSLayoutConstraint.activate([
            restaurantNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0),
            restaurantNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            restaurantNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            
            totalItemLabel.topAnchor.constraint(equalTo: restaurantNameLabel.bottomAnchor, constant: 8.0),
            totalItemLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            totalItemLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            totalItemLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0),
        ])
    }
}
