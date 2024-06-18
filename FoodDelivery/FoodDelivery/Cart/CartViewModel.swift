//
//  CartViewModel.swift
//  FoodDelivery
//
//  Created by William on 18/6/24.
//

import Foundation

protocol CartViewModelProtocol: AnyObject {
    func onViewDidLoad()
    var delegate: CartViewModelDelegate? { get set }
    func getCartCellList() -> [CartCellModel]
    func onDidSelectCart(index: Int)
}

protocol CartViewModelDelegate: AnyObject {
    func setupView()
    func reloadData()
    func navigateToRestaurantPage(cartData: CartData)
}

class CartViewModel: CartViewModelProtocol {
    weak var delegate: CartViewModelDelegate?
    
    private var cartCellList: [CartCellModel] = []
    
    func onViewDidLoad() {
        delegate?.setupView()
        setupCartList()
    }
    
    func getCartCellList() -> [CartCellModel] {
        return cartCellList
    }
    
    func onDidSelectCart(index: Int) {
        //navigasi ke restaurant vc
        //passing cart data
        let cartData: CartData = SavedCartService.shared.loadSavedCarts()[index]
        delegate?.navigateToRestaurantPage(cartData: cartData)
    }
}

private extension CartViewModel {
    func setupCartList() {
        var cartCellModels: [CartCellModel] = []
        let cartList: [CartData] = SavedCartService.shared.loadSavedCarts()
        for cart in cartList {
            let cellModel: CartCellModel = CartCellModel(restaurantName: cart.restaurantData.name, totalItem: "\(MenuCartService.shared.getTotalOrder(cartData: cart)) items")
            cartCellModels.append(cellModel)
        }
        cartCellList = cartCellModels
        delegate?.reloadData()
    }
}
