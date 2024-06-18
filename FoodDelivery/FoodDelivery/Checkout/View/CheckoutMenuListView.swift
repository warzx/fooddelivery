//
//  CheckoutMenuListView.swift
//  FoodDelivery
//
//  Created by William on 18/6/24.
//

import UIKit

protocol CheckoutMenuListViewDelegate: AnyObject {
    func onEditButtonDidTapped(orderIndex: Int, menuIndex: Int)
    func onDecreaseButtonDidTapped(orderIndex: Int, menuIndex: Int, qty: Int)
    func onIncreaseButtonDidTapped(orderIndex: Int, menuIndex: Int, qty: Int)
}

class CheckoutMenuListView: UIView {
    weak var delegate: CheckoutMenuListViewDelegate?
    
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 24.0, weight: .bold)
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
    
    func setupMenuOrderList(menuOrderList: [MenuOrder]) {
        titleLabel.text = menuOrderList.first?.menu.name
        
        for (index, menuOrder) in menuOrderList.enumerated() {
            let view: MenuOrderView = MenuOrderView(frame: .zero)
            view.tag = index
            view.delegate = self
            view.translatesAutoresizingMaskIntoConstraints = false
            //setup data
            view.setupMenuOrder(menuOrder: menuOrder)
            stackView.addArrangedSubview(view)
        }
    }
}

private extension CheckoutMenuListView {
    func setupView() {
        addSubview(titleLabel)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.0),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.0),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension CheckoutMenuListView: MenuOrderViewDelegate {
    func onEditButtonDidTapped(index: Int) {
        delegate?.onEditButtonDidTapped(orderIndex: index, menuIndex: tag)
    }
    
    func onDecreaseButtonDidTapped(index: Int, qty: Int) {
        delegate?.onDecreaseButtonDidTapped(orderIndex: index, menuIndex: tag, qty: qty)
    }
    
    func onIncreaseButtonDidTapped(index: Int, qty: Int) {
        delegate?.onIncreaseButtonDidTapped(orderIndex: index, menuIndex: tag, qty: qty)
    }
}
