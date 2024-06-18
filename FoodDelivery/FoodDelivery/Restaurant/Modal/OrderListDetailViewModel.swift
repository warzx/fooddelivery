//
//  OrderListDetailViewModel.swift
//  FoodDelivery
//
//  Created by William on 17/6/24.
//

import Foundation

protocol OrderListDetailViewModelProtocol: AnyObject {
    func onViewDidLoad()
    var delegate: OrderListDetailViewModelDelegate? { get set }
    func onEditButtonDidTapped(index: Int)
    func onDecreaseButtonDidTapped(index: Int, qty: Int)
    func onIncreaseButtonDidTapped(index: Int, qty: Int)
    func onAddToCartButtonDidTapped()
}

protocol OrderListDetailViewModelDelegate: AnyObject {
    func setupView(with menuOrderList: [MenuOrder])
    func dismissModal(completion: @escaping () -> Void)
}

protocol OrderListDetailViewModelAction: AnyObject {
    func navigateToMenuDetail(menuOrder: MenuOrder, isEditing: Bool)
}

class OrderListDetailViewModel: OrderListDetailViewModelProtocol {
    weak var delegate: OrderListDetailViewModelDelegate?
    weak var action: OrderListDetailViewModelAction?
    
    private var menuOrderList: [MenuOrder] = []
    
    init(menuOrderList: [MenuOrder]) {
        self.menuOrderList = menuOrderList
    }
    
    func onViewDidLoad() {
        delegate?.setupView(with: menuOrderList)
    }
    
    func onEditButtonDidTapped(index: Int) {
        let menuOrder: MenuOrder = menuOrderList[index]
        delegate?.dismissModal(completion: {
            self.action?.navigateToMenuDetail(menuOrder: menuOrder, isEditing: true)
        })
    }
    
    func onDecreaseButtonDidTapped(index: Int, qty: Int) {
        menuOrderList[index].qty = qty
        MenuCartService.shared.updateOrder(menuOrder: menuOrderList[index])
    }
    
    func onIncreaseButtonDidTapped(index: Int, qty: Int) {
        menuOrderList[index].qty = qty
        MenuCartService.shared.updateOrder(menuOrder: menuOrderList[index])
    }
    
    func onAddToCartButtonDidTapped() {
        if let firstMenu: MenuData = menuOrderList.first?.menu {
            let menuOrder: MenuOrder = MenuOrder(menu: firstMenu, qty: 1)
            delegate?.dismissModal(completion: {
                self.action?.navigateToMenuDetail(menuOrder: menuOrder, isEditing: false)
            })
        }
    }
}
