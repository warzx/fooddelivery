//
//  CheckoutViewController.swift
//  FoodDelivery
//
//  Created by William on 18/6/24.
//

import UIKit

class CheckoutViewController: UIViewController {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var locationView: CheckoutLocationView = {
        let locationView: CheckoutLocationView = CheckoutLocationView(frame: .zero)
        locationView.translatesAutoresizingMaskIntoConstraints = false
        locationView.layer.borderWidth = 1.0
        locationView.layer.borderColor = UIColor.gray.cgColor
        locationView.delegate = self
        return locationView
    }()
    
    private lazy var priceLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 24.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.text = "Total Price"
        return label
    }()
    
    private lazy var totalPriceLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 24.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Rp.0"
        label.textAlignment = .right
        return label
    }()
    
    private lazy var payButton: UIButton = {
        let button: UIButton = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 6.0
        button.layer.masksToBounds = true
        button.setTitle("Complete Payment", for: .normal)
        button.backgroundColor = .gray
        button.tintColor = .systemOrange
        button.addTarget(self, action: #selector(payButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    let viewModel: CheckoutViewModelProtocol
    
    init(viewModel: CheckoutViewModel) {
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

private extension CheckoutViewController {
    @objc
    func payButtonDidTapped() {
        viewModel.onPayButtonDidTapped()
    }
}

extension CheckoutViewController: CheckoutViewModelDelegate {
    func setupView() {
        view.backgroundColor = .white
        title = "Checkout"
        
        let bottomSeparator: UIView = UIView(frame: .zero)
        bottomSeparator.backgroundColor = .black
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        view.addSubview(locationView)
        view.addSubview(priceLabel)
        view.addSubview(totalPriceLabel)
        view.addSubview(bottomSeparator)
        view.addSubview(payButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            locationView.topAnchor.constraint(equalTo: scrollView.bottomAnchor),
            locationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            locationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: locationView.bottomAnchor, constant: 16.0),
            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            priceLabel.trailingAnchor.constraint(lessThanOrEqualTo: totalPriceLabel.leadingAnchor, constant: -16.0),
            
            totalPriceLabel.topAnchor.constraint(equalTo: locationView.bottomAnchor, constant: 16.0),
            totalPriceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            totalPriceLabel.widthAnchor.constraint(equalToConstant: 150.0),
            
            bottomSeparator.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 16.0),
            bottomSeparator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSeparator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSeparator.heightAnchor.constraint(equalToConstant: 1.0),
            
            payButton.topAnchor.constraint(equalTo: bottomSeparator.bottomAnchor, constant: 8.0),
            payButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16.0),
            payButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            payButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0)
        ])
        
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
        
    }
    
    func updateOrderListToView(menuOrderList: [MenuOrder], index: Int) {
        let checkoutMenuListView: CheckoutMenuListView = CheckoutMenuListView(frame: .zero)
        checkoutMenuListView.setupMenuOrderList(menuOrderList: menuOrderList)
        checkoutMenuListView.translatesAutoresizingMaskIntoConstraints = false
        checkoutMenuListView.delegate = self
        checkoutMenuListView.tag = index
        stackView.addArrangedSubview(checkoutMenuListView)
    }
    
    func setupTotalPrice(totalPriceString: String) {
        totalPriceLabel.text = totalPriceString
    }
    
    func presentMenuDetailModally(with menuOrder: MenuOrder) {
        let viewModel: MenuDetailViewModel = MenuDetailViewModel(menuOrder: menuOrder, isEditing: true)
        viewModel.action = self
        let viewController: MenuDetailViewController = MenuDetailViewController(viewModel: viewModel)
        viewController.preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.6)
        viewController.modalPresentationStyle = .pageSheet
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [
                .custom { _ in UIScreen.main.bounds.height * 0.6 }
            ]
            sheet.prefersGrabberVisible = true
        }
        present(viewController, animated: true)
    }
    
    func resetStackView() {
        for arrangedSubview in stackView.arrangedSubviews {
            arrangedSubview.removeFromSuperview()
        }
    }
    
    func navigateToSetLocationPage() {
        let viewModel: LocationViewModel = LocationViewModel()
        viewModel.action = self
        let viewController: LocationViewController = LocationViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func updateLocationDetails(locationName: String, locationDetails: String) {
        locationView.updateLocation(locationName: locationName, locationDetails: locationDetails)
    }
    
    func popToRootViewController() {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension CheckoutViewController: CheckoutMenuListViewDelegate {
    func onEditButtonDidTapped(orderIndex: Int, menuIndex: Int) {
        viewModel.onEditButtonDidTapped(orderIndex: orderIndex, menuIndex: menuIndex)
    }
    
    func onDecreaseButtonDidTapped(orderIndex: Int, menuIndex: Int, qty: Int) {
        viewModel.onDecreaseButtonDidTapped(orderIndex: orderIndex, menuIndex: menuIndex, qty: qty)
    }
    
    func onIncreaseButtonDidTapped(orderIndex: Int, menuIndex: Int, qty: Int) {
        viewModel.onIncreaseButtonDidTapped(orderIndex: orderIndex, menuIndex: menuIndex, qty: qty)
    }
}

extension CheckoutViewController: MenuDetailViewModelAction {
    func onDismissModal() {
        viewModel.onMenuDetailDismissModal()
    }
    
}

extension CheckoutViewController: CheckoutLocationViewDelegate {
    func onSetLocationButtonDidTapped() {
        viewModel.onSetLocationButtonDidTapped()
    }
}

extension CheckoutViewController: LocationViewModelAction {
    func onLocationPageDidPopped() {
        viewModel.onLocationPageDidPopped()
    }
    
}
