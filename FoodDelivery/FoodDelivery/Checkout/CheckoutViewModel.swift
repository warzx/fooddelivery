//
//  CheckoutViewModel.swift
//  FoodDelivery
//
//  Created by William on 18/6/24.
//

import Foundation

protocol CheckoutViewModelProtocol: AnyObject {
    func onViewDidLoad()
    var delegate: CheckoutViewModelDelegate? { get set }
    func onEditButtonDidTapped(orderIndex: Int, menuIndex: Int)
    func onDecreaseButtonDidTapped(orderIndex: Int, menuIndex: Int, qty: Int)
    func onIncreaseButtonDidTapped(orderIndex: Int, menuIndex: Int, qty: Int)
    func onMenuDetailDismissModal()
    func onSetLocationButtonDidTapped()
    func onLocationPageDidPopped()
    func onPayButtonDidTapped()
}

protocol CheckoutViewModelDelegate: AnyObject {
    func setupView()
    func updateOrderListToView(menuOrderList: [MenuOrder], index: Int)
    func setupTotalPrice(totalPriceString: String)
    func presentMenuDetailModally(with menuOrder: MenuOrder)
    func resetStackView()
    func navigateToSetLocationPage()
    func updateLocationDetails(locationName: String, locationDetails: String)
    func popToRootViewController()
}

class CheckoutViewModel: CheckoutViewModelProtocol {
    let restaurantData: RestaurantData
    init(restaurantData: RestaurantData) {
        self.restaurantData = restaurantData
    }
    
    weak var delegate: CheckoutViewModelDelegate?
    
    func onViewDidLoad() {
        delegate?.setupView()
        setupMenuOrderList()
        setupTotalPrice()
        updateLocationDetails()
    }
    
    func onEditButtonDidTapped(orderIndex: Int, menuIndex: Int) {
        let orderList: [MenuOrder] = MenuCartService.shared.getOrderList(for: restaurantData.menus[menuIndex])
        delegate?.presentMenuDetailModally(with: orderList[orderIndex])
    }
    
    func onDecreaseButtonDidTapped(orderIndex: Int, menuIndex: Int, qty: Int) {
        let orderList: [MenuOrder] = MenuCartService.shared.getOrderList(for: restaurantData.menus[menuIndex])
        let newOrder: MenuOrder = orderList[orderIndex]
        newOrder.qty = qty
        MenuCartService.shared.updateOrder(menuOrder: orderList[orderIndex])
        //update total price
        setupTotalPrice()
    }
    
    func onIncreaseButtonDidTapped(orderIndex: Int, menuIndex: Int, qty: Int) {
        let orderList: [MenuOrder] = MenuCartService.shared.getOrderList(for: restaurantData.menus[menuIndex])
        let newOrder: MenuOrder = orderList[orderIndex]
        newOrder.qty = qty
        MenuCartService.shared.updateOrder(menuOrder: orderList[orderIndex])
        //update total price
        setupTotalPrice()
    }
    
    func onMenuDetailDismissModal() {
        //update total price dan order details
        setupTotalPrice()
        //cara 2: update semua menu order
        setupMenuOrderList()
    }
    
    func onSetLocationButtonDidTapped() {
        delegate?.navigateToSetLocationPage()
    }
    
    func onLocationPageDidPopped() {
        updateLocationDetails()
    }
    
    func onPayButtonDidTapped() {
        //1. save cart data ke local storage
        guard let cartData: CartData = MenuCartService.shared.cartData else {
            return
        }
        SavedCartService.shared.saveCartData(cartData)
        //2. pop view controller ini ke root view controller
        delegate?.popToRootViewController()
    }
}

private extension CheckoutViewModel {
    func resetMenuOrderList() {
        delegate?.resetStackView()
    }
    
    func setupMenuOrderList() {
        resetMenuOrderList()
        for (index, menu) in restaurantData.menus.enumerated() {
            let orderList: [MenuOrder] = MenuCartService.shared.getOrderList(for: menu)
            //update di vc dan append tiap view di scroll view
            delegate?.updateOrderListToView(menuOrderList: orderList, index: index)
        }
    }
    
    func setupTotalPrice() {
        let totalPrice: String = "Rp.\(MenuCartService.shared.getTotalPrice())"
        delegate?.setupTotalPrice(totalPriceString: totalPrice)
    }
    
    func updateLocationDetails() {
        guard let savedLocation = SavedLocationService.shared.getSavedLocation() else {
            return
        }
        delegate?.updateLocationDetails(locationName: savedLocation.locationName, locationDetails: savedLocation.locationDetails)
    }
}
