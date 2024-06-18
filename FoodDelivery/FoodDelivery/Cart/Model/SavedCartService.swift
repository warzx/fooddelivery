//
//  SavedCartService.swift
//  FoodDelivery
//
//  Created by William on 18/6/24.
//

import Foundation

class SavedCartService {
    static let shared: SavedCartService = SavedCartService()
    
    func loadSavedCarts() -> [CartData] {
        if let savedCartData = UserDefaults.standard.object(forKey: "savedCarts") as? Data {
                let decoder = JSONDecoder()
                if let loadedCartData = try? decoder.decode([CartData].self, from: savedCartData) {
                    return loadedCartData
                }
            }
            return []
    }
    
    func saveCartData(_ cartData: CartData) {
        var savedCarts: [CartData] = loadSavedCarts()
        if let existingCartIndex = savedCarts.firstIndex(where: { $0.restaurantData.name == cartData.restaurantData.name }) {
            //update existingCart
            savedCarts[existingCartIndex] = cartData
        }
        else {
            //add new
            savedCarts.append(cartData)
        }
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(savedCarts) {
            UserDefaults.standard.set(encoded, forKey: "savedCarts")
        }
    }
}
