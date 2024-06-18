//
//  OrderListDetailViewController.swift
//  FoodDelivery
//
//  Created by William on 17/6/24.
//

import UIKit

class OrderListDetailViewController: UIViewController {
    private lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 24.0, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var addToCartButton: UIButton = {
        let button: UIButton = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 6.0
        button.layer.masksToBounds = true
        button.setTitle("Add another to Cart", for: .normal)
        button.backgroundColor = .gray
        button.tintColor = .systemOrange
        button.addTarget(self, action: #selector(addToCartButtonDidTapped), for: .touchUpInside)
        return button
    }()

    let viewModel: OrderListDetailViewModelProtocol
    
    init(viewModel: OrderListDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onViewDidLoad()
    }
}

extension OrderListDetailViewController: OrderListDetailViewModelDelegate {
    func setupView(with menuOrderList: [MenuOrder]) {
        view.backgroundColor = .white
        let topSeparator: UIView = UIView(frame: .zero)
        topSeparator.backgroundColor = .gray
        topSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonSeparator: UIView = UIView(frame: .zero)
        buttonSeparator.backgroundColor = .gray
        buttonSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        view.addSubview(topSeparator)
        view.addSubview(scrollView)
        view.addSubview(buttonSeparator)
        view.addSubview(addToCartButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.0),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            
            topSeparator.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.0),
            topSeparator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topSeparator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topSeparator.heightAnchor.constraint(equalToConstant: 1.0),
            
            scrollView.topAnchor.constraint(equalTo: topSeparator.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            buttonSeparator.topAnchor.constraint(equalTo: scrollView.bottomAnchor),
            buttonSeparator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonSeparator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonSeparator.heightAnchor.constraint(equalToConstant: 1.0),
            
            addToCartButton.topAnchor.constraint(equalTo: buttonSeparator.bottomAnchor, constant: 16.0),
            addToCartButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            addToCartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            addToCartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16.0)
        ])
        
        //set stack view dengan menu order list
        updateMenuOrderList(with: menuOrderList)
    }
    
    func dismissModal(completion: @escaping () -> Void) {
        dismiss(animated: true, completion: completion)
    }
}

private extension OrderListDetailViewController {
    func updateMenuOrderList(with menuOrderList: [MenuOrder]) {
        titleLabel.text = menuOrderList.first?.menu.name
        let stackView: UIStackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
        
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
    
    @objc
    func addToCartButtonDidTapped() {
        viewModel.onAddToCartButtonDidTapped()
    }
}

extension OrderListDetailViewController: MenuOrderViewDelegate {
    func onEditButtonDidTapped(index: Int) {
        viewModel.onEditButtonDidTapped(index: index)
    }
    
    func onDecreaseButtonDidTapped(index: Int, qty: Int) {
        viewModel.onDecreaseButtonDidTapped(index: index, qty: qty)
    }
    
    func onIncreaseButtonDidTapped(index: Int, qty: Int) {
        viewModel.onIncreaseButtonDidTapped(index: index, qty: qty)
    }
}
