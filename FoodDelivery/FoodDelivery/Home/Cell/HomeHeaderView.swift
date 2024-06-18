//
//  HomeHeaderView.swift
//  FoodDelivery
//
//  Created by William on 15/6/24.
//

import UIKit

class HomeHeaderView: UICollectionReusableView {
    private lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 32.0, weight: .bold)
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
    
    func setupTitle(title: String) {
        titleLabel.text = title
    }
    
    static func getHeight() -> CGFloat {
        return 64.0
    }
}

private extension HomeHeaderView {
    func setupView() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.0),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.0)
        ])
        backgroundColor = .white
    }
}
