//
//  CartViewController.swift
//  FoodDelivery
//
//  Created by William on 13/6/24.
//

import UIKit

class CartViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView: UITableView = UITableView(frame: .zero)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CartCell.self, forCellReuseIdentifier: "cart_cell")
        return tableView
    }()
    
    let viewModel: CartViewModelProtocol
    
    init(viewModel: CartViewModel) {
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

extension CartViewController: CartViewModelDelegate {
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func navigateToRestaurantPage(cartData: CartData) {
        let viewModel: RestaurantViewModel = RestaurantViewModel(restaurantData: cartData.restaurantData, cartData: cartData)
        let viewController: RestaurantViewController = RestaurantViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getCartCellList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cart_cell") as? CartCell else { return UITableViewCell() }
        cell.setupCellModel(cellModel: viewModel.getCartCellList()[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.onDidSelectCart(index: indexPath.row)
    }
    
}
