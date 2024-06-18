//
//  HomeTabBarViewModel.swift
//  FoodDelivery
//
//  Created by William on 13/6/24.
//

import Foundation

protocol HomeTabBarViewModelProtocol: AnyObject {
    func onViewWillAppear()
    var delegate: HomeTabBarViewModelDelegate? { get set }
}

protocol HomeTabBarViewModelDelegate: AnyObject {
    func setupView()
}

class HomeTabBarViewModel: HomeTabBarViewModelProtocol {
    weak var delegate: HomeTabBarViewModelDelegate?
    
    func onViewWillAppear() {
        delegate?.setupView()
    }
}
