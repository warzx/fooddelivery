//
//  MenuDetailViewModel.swift
//  FoodDelivery
//
//  Created by William on 17/6/24.
//

import Foundation

protocol MenuDetailViewModelProtocol: AnyObject {
    func onViewDidLoad()
    var delegate: MenuDetailViewModelDelegate? { get set }
    func onDecreaseButtonDidTapped(qty: Int)
    func onIncreaseButtonDidTapped(qty: Int)
    func onAddToCartButtonDidTapped(qty: Int, notes: String?)
}

protocol MenuDetailViewModelDelegate: AnyObject {
    func setupView()
    func configureView(with menuOrder: MenuOrder)
    func updateButtonText(text: String)
    func dismissModal(completion: @escaping () -> Void)
}

protocol MenuDetailViewModelAction: AnyObject {
    func onDismissModal()
}

class MenuDetailViewModel: MenuDetailViewModelProtocol {
    weak var delegate: MenuDetailViewModelDelegate?
    weak var action: MenuDetailViewModelAction?
    
    private let menuOrder: MenuOrder
    private var isEditing: Bool = false
    
    init(menuOrder: MenuOrder, isEditing: Bool = false) {
        self.menuOrder = menuOrder
        self.isEditing = isEditing
    }
    
    func onViewDidLoad() {
        delegate?.setupView()
        delegate?.configureView(with: menuOrder)
        delegate?.updateButtonText(text: "Add To Cart - Total Rp. \(menuOrder.menu.price * Float(menuOrder.qty))")
    }
    
    func onDecreaseButtonDidTapped(qty: Int) {
        if qty == 0 {
            //update button jd "Remove Order"
            delegate?.updateButtonText(text: "Remove Order")
        }
        else {
            //update button jd "Add To Cart - Total Rpxxx"
            delegate?.updateButtonText(text: "Add To Cart - Total Rp. \(menuOrder.menu.price * Float(qty))")
        }
    }
    
    func onIncreaseButtonDidTapped(qty: Int) {
        //update button jd "Add To Cart - Total Rpxxx"
        delegate?.updateButtonText(text: "Add To Cart - Total Rp. \(menuOrder.menu.price * Float(qty))")
    }
    
    func onAddToCartButtonDidTapped(qty: Int, notes: String?) {
        let newMenuOrder: MenuOrder = MenuOrder(menu: menuOrder.menu, qty: qty, notes: notes)
        if isEditing {
            guard let cartData = MenuCartService.shared.cartData else { return }
            if let index = cartData.orderList.firstIndex(where: { $0.menu.name == menuOrder.menu.name && $0.notes?.lowercased() == menuOrder.notes?.lowercased() }) {
                MenuCartService.shared.overrideMenuOrder(with: index, menuOrder: newMenuOrder)
            }
        }
        else {
            let newMenuOrder: MenuOrder = MenuOrder(menu: menuOrder.menu, qty: qty, notes: notes)
            MenuCartService.shared.updateOrder(menuOrder: newMenuOrder)
        }
        delegate?.dismissModal(completion: {
            self.action?.onDismissModal()
        })
    }
}
