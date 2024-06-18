//
//  MenuCartService.swift
//  FoodDelivery
//
//  Created by William on 17/6/24.
//

import Foundation

class CartData: Codable {
    var restaurantData: RestaurantData
    var orderList: [MenuOrder]
    
    init(restaurantData: RestaurantData, orderList: [MenuOrder]) {
        self.restaurantData = restaurantData
        self.orderList = orderList
    }
}

class MenuCartService {
    static let shared: MenuCartService = MenuCartService()
    
    var cartData: CartData?
    
    /// add, update, or delete menu order
    /// - Parameter menuOrder: the new menu order
    func updateOrder(menuOrder: MenuOrder) {
        guard let cartData else { return }
        if let index = cartData.orderList.firstIndex(where: { $0.menu.name == menuOrder.menu.name && $0.notes?.lowercased() == menuOrder.notes?.lowercased() }) {
            //menu order already exist, then update menu order with the new one
            //if new order = 0, then delete the menu order
            if menuOrder.qty == 0 {
                cartData.orderList.remove(at: index)
            } else {
                cartData.orderList[index] = menuOrder
            }
        }
        else {
            //add new order
            cartData.orderList.append(menuOrder)
        }
    }
    
    func overrideMenuOrder(with index: Int, menuOrder: MenuOrder) {
        guard let cartData else { return }
        if menuOrder.qty == 0 {
            cartData.orderList.remove(at: index)
        }
        else {
            cartData.orderList[index] = menuOrder
        }
    }
    
    func getTotalOrder(cartData: CartData) -> Int {
        var totalOrder: Int = 0
        for order in cartData.orderList {
            totalOrder += order.qty
        }
        return totalOrder
    }
    
    func getTotalOrder() -> Int {
        guard let cartData else { return 0 }
        return getTotalOrder(cartData: cartData)
    }
    
    func getTotalPrice() -> Float {
        guard let cartData else { return 0 }
        var totalPrice: Float = 0
        for order in cartData.orderList {
            totalPrice += (order.menu.price * Float(order.qty))
        }
        return totalPrice
    }
    
    func getTotalOrder(for menu: MenuData) -> Int {
        var totalOrder: Int = 0
        guard let cartData else { return 0 }
        for order in cartData.orderList {
            if menu.name == order.menu.name {
                totalOrder += order.qty
            }
        }
        return totalOrder
    }
    
    func getOrderList(for menu: MenuData) -> [MenuOrder] {
        var orderList: [MenuOrder] = []
        guard let cartData else { return [] }
        for order in cartData.orderList {
            if menu.name == order.menu.name {
                orderList.append(order)
            }
        }
        return orderList
    }
}

