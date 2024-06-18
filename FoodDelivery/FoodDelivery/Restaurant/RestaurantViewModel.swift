//
//  RestaurantViewModel.swift
//  FoodDelivery
//
//  Created by William on 16/6/24.
//

import Foundation

protocol RestaurantViewModelProtocol: AnyObject {
    func onViewDidLoad()
    func onViewWillAppear()
    var delegate: RestaurantViewModelDelegate? { get set }
    func getMenuListModel() -> [MenuListCellModel]
    func onAddButtonDidTapped(cellIndex: Int)
    func onMenuImageViewDidTapped(cellIndex: Int)
    func onDismissModal()
    func onCheckoutButtonDidTapped()
    func getRestaurantData() -> RestaurantData
}

protocol RestaurantViewModelDelegate: AnyObject {
    func setupView(restaurantName: String, cuisineName: String, location: String)
    func reloadData()
    func presentMenuDetailModally(with menuOrder: MenuOrder)
    func presentOrderListDetailModally(with menuListOrder: [MenuOrder])
    func updateCheckoutButtonTitle(title: String)
    func navigateToCheckoutPage()
}

class RestaurantViewModel: RestaurantViewModelProtocol {
    weak var delegate: RestaurantViewModelDelegate?
    
    private let restaurantData: RestaurantData
    private let cartData: CartData?
    
    private var menuListModel: [MenuListCellModel] = []
    
    init(restaurantData: RestaurantData, cartData: CartData? = nil) {
        self.restaurantData = restaurantData
        self.cartData = cartData
    }
    
    func onViewDidLoad() {
        delegate?.setupView(restaurantName: restaurantData.name,
                            cuisineName: restaurantData.cuisine,
                            location: restaurantData.location.city)
        setupMenuListModel()
        initializeMenuCart()
    }
    
    func onViewWillAppear() {
        updateMenuListModel()
    }
    
    func getMenuListModel() -> [MenuListCellModel] {
        return menuListModel
    }
    
    func onAddButtonDidTapped(cellIndex: Int) {
        let menuOrders =  MenuCartService.shared.getOrderList(for: restaurantData.menus[cellIndex])
        if !menuOrders.isEmpty {
            delegate?.presentOrderListDetailModally(with: menuOrders)
        }
        else {
            let newMenuOrder: MenuOrder = MenuOrder(menu: restaurantData.menus[cellIndex], qty: 1)
            delegate?.presentMenuDetailModally(with: newMenuOrder)
        }
        
    }
    
    func onMenuImageViewDidTapped(cellIndex: Int) {
        let menuOrders =  MenuCartService.shared.getOrderList(for: restaurantData.menus[cellIndex])
        if !menuOrders.isEmpty {
            delegate?.presentOrderListDetailModally(with: menuOrders)
        }
        else {
            let newMenuOrder: MenuOrder = MenuOrder(menu: restaurantData.menus[cellIndex], qty: 1)
            delegate?.presentMenuDetailModally(with: newMenuOrder)
        }
    }
    
    func onDismissModal() {
        updateMenuListModel()
    }
    
    func onCheckoutButtonDidTapped() {
        if let orderList = MenuCartService.shared.cartData?.orderList, !orderList.isEmpty {
            delegate?.navigateToCheckoutPage()
        }
    }
    
    func getRestaurantData() -> RestaurantData {
        return restaurantData
    }
}

private extension RestaurantViewModel {
    func initializeMenuCart() {
        if let cartData {
            //pakai existing cart data
            MenuCartService.shared.cartData = cartData
        }
        else {
            //pakai cart baru
            MenuCartService.shared.cartData = CartData(restaurantData: restaurantData, orderList: [])
        }
    }
    
    func setupMenuListModel() {
        var menuList: [MenuListCellModel] = []
        for menu in restaurantData.menus {
            let menuCellModel: MenuListCellModel = MenuListCellModel(menuImageURL: menu.imageURL, menuName: menu.name, menuDescription: menu.description, menuPrice: "Rp. \(menu.price)", addTextString: "Add")
            menuList.append(menuCellModel)
        }
        menuListModel = menuList
        delegate?.reloadData()
    }
    
    func updateMenuListModel() {
        for (index ,menuModel) in menuListModel.enumerated() {
            if let menu = restaurantData.menus.filter({ $0.name == menuModel.menuName}).first {
                let totalMenuItem: Int = MenuCartService.shared.getTotalOrder(for: menu)
                menuListModel[index].addTextString = totalMenuItem == 0 ? "Add" : "\(totalMenuItem) in Cart"
            }
        }
        delegate?.reloadData()
        let totalItem: Int = MenuCartService.shared.getTotalOrder()
        let totalPrice: Float = MenuCartService.shared.getTotalPrice()
        delegate?.updateCheckoutButtonTitle(title: totalItem == 0 ? "Checkout" : "\(totalItem) items, Total Rp. \(totalPrice)")
    }
}
