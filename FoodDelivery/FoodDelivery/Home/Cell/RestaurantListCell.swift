//
//  RestaurantListCell.swift
//  FoodDelivery
//
//  Created by William on 15/6/24.
//

import UIKit

class RestaurantListCell: UICollectionViewCell {
    private lazy var restaurantImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var restaurantNameLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 24.0, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cuisineLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12.0, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func getHeight() -> CGFloat {
        return 290.0
    }
    
    func setupData(cellModel: RestaurantListCellModel) {
        //1. buat function untuk load data dari URL menjadi UIImage
        //2. set UIImage hasil load ke restaurantImageView
        if let restaurantImageURL: String = cellModel.restaurantImageURL,
           let imageURL: URL = URL(string: restaurantImageURL) {
            restaurantImageView.load(url: imageURL)
        }
        restaurantNameLabel.text = cellModel.restaurantName
        cuisineLabel.text = cellModel.cuisineName
    }
}

private extension RestaurantListCell {
    func setupView() {
        contentView.addSubview(restaurantImageView)
        contentView.addSubview(restaurantNameLabel)
        contentView.addSubview(cuisineLabel)
        
        NSLayoutConstraint.activate([
            restaurantImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            restaurantImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            restaurantImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            restaurantImageView.heightAnchor.constraint(equalToConstant: 200.0),
            
            restaurantNameLabel.topAnchor.constraint(equalTo: restaurantImageView.bottomAnchor, constant: 16.0),
            restaurantNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            restaurantNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            
            cuisineLabel.topAnchor.constraint(equalTo: restaurantNameLabel.bottomAnchor, constant: 16.0),
            cuisineLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            cuisineLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            cuisineLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0)
        ])
        
        contentView.backgroundColor = .white
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 6.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.black.cgColor
    }
}
