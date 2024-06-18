//
//  MenuQtyStepperView.swift
//  FoodDelivery
//
//  Created by William on 17/6/24.
//

import UIKit

protocol MenuQtyStepperViewDelegate: AnyObject {
    func onDecreaseButtonDidTapped()
    func onIncreaseButtonDidTapped()
}

class MenuQtyStepperView: UIView {
    weak var delegate: MenuQtyStepperViewDelegate?
    private lazy var decreaseButton: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.setImage(UIImage(systemName: "minus.square"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
        button.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        button.addTarget(self, action: #selector(decreaseButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var increaseButton: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.square"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
        button.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        button.addTarget(self, action: #selector(increaseButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var qtyLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var currentQty: Int = 0 {
        didSet {
            qtyLabel.text = "\(currentQty)"
        }
    }
    var limitQty: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MenuQtyStepperView {
    func setupView() {
        qtyLabel.text = "0"
        
        let stackView: UIStackView = UIStackView(arrangedSubviews: [decreaseButton, qtyLabel, increaseButton])
        stackView.spacing = 4.0
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc
    func decreaseButtonDidTapped() {
        if currentQty > limitQty {
            currentQty -= 1
        }
        delegate?.onDecreaseButtonDidTapped()
    }
    
    @objc
    func increaseButtonDidTapped() {
        currentQty += 1
        delegate?.onIncreaseButtonDidTapped()
    }
}
