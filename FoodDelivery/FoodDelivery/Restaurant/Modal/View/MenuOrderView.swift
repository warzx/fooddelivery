//
//  MenuOrderView.swift
//  FoodDelivery
//
//  Created by William on 17/6/24.
//

import UIKit

protocol MenuOrderViewDelegate: AnyObject {
    func onEditButtonDidTapped(index: Int)
    func onDecreaseButtonDidTapped(index: Int, qty: Int)
    func onIncreaseButtonDidTapped(index: Int, qty: Int)
}

class MenuOrderView: UIView {
    weak var delegate: MenuOrderViewDelegate?
    private lazy var notesTitleLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Notes:"
        return label
    }()
    
    private lazy var notesLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12.0, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var editButton: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.setTitle("Edit", for: .normal)
        button.setImage(UIImage(systemName: "pencil.line"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 6.0
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(editButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var stepperView: MenuQtyStepperView = {
        let stepperView: MenuQtyStepperView = MenuQtyStepperView(frame: .zero)
        stepperView.translatesAutoresizingMaskIntoConstraints = false
        stepperView.limitQty = 1
        stepperView.delegate = self
        return stepperView
    }()
    
    private var menuOrder: MenuOrder?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupMenuOrder(menuOrder: MenuOrder) {
        self.menuOrder = menuOrder
        notesLabel.text = menuOrder.notes
        priceLabel.text = "Rp. \(menuOrder.menu.price * Float(menuOrder.qty))"
        stepperView.currentQty = menuOrder.qty
    }
}

private extension MenuOrderView {
    func setupView() {
        backgroundColor = .white
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.gray.cgColor
        addSubview(notesTitleLabel)
        addSubview(notesLabel)
        addSubview(priceLabel)
        addSubview(editButton)
        addSubview(stepperView)
        
        NSLayoutConstraint.activate([
            notesTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.0),
            notesTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0),
            
            notesLabel.leadingAnchor.constraint(equalTo: notesTitleLabel.trailingAnchor, constant: 4.0),
            notesLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.0),
            notesLabel.trailingAnchor.constraint(lessThanOrEqualTo: priceLabel.leadingAnchor, constant: -16.0),
            
            priceLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.0),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.0),
            priceLabel.widthAnchor.constraint(equalToConstant: 80.0),
            
            editButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.0),
            editButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0),
            
            stepperView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.0),
            stepperView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.0),
            
            heightAnchor.constraint(equalToConstant: 100.0),
            widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        ])
    }
    
    func updatePrice() {
        guard let menuOrder else { return }
        priceLabel.text = "Rp. \(menuOrder.menu.price * Float(stepperView.currentQty))"
    }
    
    @objc
    func editButtonDidTapped() {
        delegate?.onEditButtonDidTapped(index: tag)
    }
}

extension MenuOrderView: MenuQtyStepperViewDelegate {
    func onDecreaseButtonDidTapped() {
        updatePrice()
        delegate?.onDecreaseButtonDidTapped(index: tag, qty: stepperView.currentQty)
    }
    
    func onIncreaseButtonDidTapped() {
        updatePrice()
        delegate?.onIncreaseButtonDidTapped(index: tag, qty: stepperView.currentQty)
    }
}
