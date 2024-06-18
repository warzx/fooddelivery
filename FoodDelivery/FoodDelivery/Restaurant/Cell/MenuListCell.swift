//
//  MenuListCell.swift
//  FoodDelivery
//
//  Created by William on 16/6/24.
//

import UIKit

protocol MenuListCellDelegate: AnyObject {
    func onAddButtonDidTapped(cellIndex: Int)
    func onMenuImageViewDidTapped(cellIndex: Int)
}

class MenuListCell: UICollectionViewCell {
    weak var delegate: MenuListCellDelegate?
    
    private lazy var menuImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        imageView.layer.cornerRadius = 6.0
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(menuImageViewDidTapped))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        return imageView
    }()
    
    private lazy var menuLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var menuDescriptionLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button: UIButton = UIButton(frame: .zero)
        button.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        button.setTitle("Add", for: .normal)
        button.layer.cornerRadius = 10.0
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemOrange
        button.backgroundColor = .gray
        button.addTarget(self, action: #selector(addButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    func setupCellModel(cellModel: MenuListCellModel) {
        if let imageURL: URL = URL(string: cellModel.menuImageURL) {
            menuImageView.load(url: imageURL)
        }
        menuLabel.text = cellModel.menuName
        menuDescriptionLabel.text = cellModel.menuDescription
        priceLabel.text = cellModel.menuPrice
        addButton.setTitle(cellModel.addTextString, for: .normal)
    }
    
    static func getHeight() -> CGFloat {
        return 112.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MenuListCell {
    func setupView() {
        let topSeparator: UIView = UIView(frame: .zero)
        topSeparator.translatesAutoresizingMaskIntoConstraints = false
        topSeparator.backgroundColor = .gray
        
        let bottomSeparator: UIView = UIView(frame: .zero)
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
        bottomSeparator.backgroundColor = .gray
        
        contentView.addSubview(topSeparator)
        contentView.addSubview(menuImageView)
        contentView.addSubview(menuLabel)
        contentView.addSubview(menuDescriptionLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(addButton)
        contentView.addSubview(bottomSeparator)
        
        NSLayoutConstraint.activate([
            topSeparator.topAnchor.constraint(equalTo: contentView.topAnchor),
            topSeparator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            topSeparator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            topSeparator.heightAnchor.constraint(equalToConstant: 1.0),
            
            menuImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0),
            menuImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            menuImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0),
            
            menuLabel.topAnchor.constraint(equalTo: menuImageView.topAnchor),
            menuLabel.leadingAnchor.constraint(equalTo: menuImageView.trailingAnchor, constant: 16.0),
            menuLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            
            menuDescriptionLabel.topAnchor.constraint(equalTo: menuLabel.bottomAnchor, constant: 4.0),
            menuDescriptionLabel.leadingAnchor.constraint(equalTo: menuImageView.trailingAnchor, constant: 16.0),
            menuDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            
            priceLabel.bottomAnchor.constraint(equalTo: menuImageView.bottomAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: menuImageView.trailingAnchor, constant: 16.0),
            
            addButton.bottomAnchor.constraint(equalTo: menuImageView.bottomAnchor),
            addButton.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 16.0),
            addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            addButton.widthAnchor.constraint(equalToConstant: 80.0),
            
            bottomSeparator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomSeparator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            bottomSeparator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            bottomSeparator.heightAnchor.constraint(equalToConstant: 1.0),
        ])
    }
    
    @objc
    func addButtonDidTapped() {
        delegate?.onAddButtonDidTapped(cellIndex: tag)
    }
    
    @objc
    func menuImageViewDidTapped() {
        delegate?.onMenuImageViewDidTapped(cellIndex: tag)
    }
}
