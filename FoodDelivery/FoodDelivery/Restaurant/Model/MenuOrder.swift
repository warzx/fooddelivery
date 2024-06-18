//
//  MenuOrder.swift
//  FoodDelivery
//
//  Created by William on 17/6/24.
//

import Foundation

class MenuOrder: Codable {
    var menu: MenuData
    var qty: Int
    var notes: String?
    
    init(menu: MenuData, qty: Int, notes: String? = nil) {
        self.menu = menu
        self.qty = qty
        self.notes = notes
    }
}
