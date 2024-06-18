//
//  RestaurantViewController.swift
//  FoodDelivery
//
//  Created by William on 16/6/24.
//

import UIKit

class RestaurantViewController: UIViewController {
    
    private lazy var cuisineLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 24.0, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var locationPinImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "mappin.and.ellipse")
        imageView.heightAnchor.constraint(equalToConstant: 16.0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 16.0).isActive = true
        return imageView
    }()
    
    private lazy var locationPinLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var menuListLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 28.0, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Menu List"
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MenuListCell.self, forCellWithReuseIdentifier: "menu_list_cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var checkoutButton: UIButton = {
        let button: UIButton = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 6.0
        button.layer.masksToBounds = true
        button.setTitle("Checkout", for: .normal)
        button.backgroundColor = .gray
        button.tintColor = .systemOrange
        button.addTarget(self, action: #selector(checkoutButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    let viewModel: RestaurantViewModelProtocol
    
    init(viewModel: RestaurantViewModel) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.onViewWillAppear()
    }

}

private extension RestaurantViewController {
    func presentMenuDetailModally(with menuOrder: MenuOrder, isEditing: Bool) {
        let viewModel: MenuDetailViewModel = MenuDetailViewModel(menuOrder: menuOrder, isEditing: isEditing)
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
    
    @objc
    func checkoutButtonDidTapped() {
        viewModel.onCheckoutButtonDidTapped()
    }
}

extension RestaurantViewController: RestaurantViewModelDelegate {
    func setupView(restaurantName: String, cuisineName: String, location: String) {
        view.backgroundColor = .white
        title = restaurantName
        cuisineLabel.text = cuisineName
        locationPinLabel.text = location
        
        let separator: UIView = UIView(frame: .zero)
        separator.backgroundColor = .gray
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        let separatorButton: UIView = UIView(frame: .zero)
        separatorButton.backgroundColor = .gray
        separatorButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(cuisineLabel)
        view.addSubview(locationPinImageView)
        view.addSubview(locationPinLabel)
        view.addSubview(separator)
        view.addSubview(menuListLabel)
        view.addSubview(collectionView)
        view.addSubview(separatorButton)
        view.addSubview(checkoutButton)
        
        NSLayoutConstraint.activate([
            cuisineLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cuisineLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            cuisineLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            
            locationPinImageView.topAnchor.constraint(equalTo: cuisineLabel.bottomAnchor, constant: 16.0),
            locationPinImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            
            locationPinLabel.leadingAnchor.constraint(equalTo: locationPinImageView.trailingAnchor, constant: 8.0),
            locationPinLabel.centerYAnchor.constraint(equalTo: locationPinImageView.centerYAnchor),
            locationPinLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            
            separator.topAnchor.constraint(equalTo: locationPinImageView.bottomAnchor, constant: 16.0),
            separator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1.0),
            
            menuListLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 16.0),
            menuListLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            menuListLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            
            collectionView.topAnchor.constraint(equalTo: menuListLabel.bottomAnchor, constant: 16.0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            separatorButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            separatorButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separatorButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separatorButton.heightAnchor.constraint(equalToConstant: 1.0),
            
            checkoutButton.topAnchor.constraint(equalTo: separatorButton.bottomAnchor, constant: 16.0),
            checkoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            checkoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            checkoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16.0),
        ])
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func presentMenuDetailModally(with menuOrder: MenuOrder) {
        presentMenuDetailModally(with: menuOrder, isEditing: false)
    }
    
    func presentOrderListDetailModally(with menuListOrder: [MenuOrder]) {
        let viewModel: OrderListDetailViewModel = OrderListDetailViewModel(menuOrderList: menuListOrder)
        viewModel.action = self
        let viewController: OrderListDetailViewController = OrderListDetailViewController(viewModel: viewModel)
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
    
    func updateCheckoutButtonTitle(title: String) {
        checkoutButton.setTitle(title, for: .normal)
    }
    
    func navigateToCheckoutPage() {
        let viewModel: CheckoutViewModel = CheckoutViewModel(restaurantData: viewModel.getRestaurantData())
        let viewController: CheckoutViewController = CheckoutViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension RestaurantViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getMenuListModel().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menu_list_cell", for: indexPath) as? MenuListCell else { return UICollectionViewCell() }
        cell.delegate = self
        cell.setupCellModel(cellModel: viewModel.getMenuListModel()[indexPath.row])
        cell.tag = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: MenuListCell.getHeight())
    }
}

extension RestaurantViewController: MenuListCellDelegate {
    func onAddButtonDidTapped(cellIndex: Int) {
        viewModel.onAddButtonDidTapped(cellIndex: cellIndex)
    }
    
    func onMenuImageViewDidTapped(cellIndex: Int) {
        viewModel.onMenuImageViewDidTapped(cellIndex: cellIndex)
    }
}

extension RestaurantViewController: MenuDetailViewModelAction {
    func onDismissModal() {
        viewModel.onDismissModal()
    }
}

extension RestaurantViewController: OrderListDetailViewModelAction {
    func navigateToMenuDetail(menuOrder: MenuOrder, isEditing: Bool) {
        presentMenuDetailModally(with: menuOrder, isEditing: isEditing)
    }
}
