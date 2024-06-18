//
//  SearchViewModel.swift
//  FoodDelivery
//
//  Created by William on 16/6/24.
//

import Foundation

protocol SearchViewModelProtocol: AnyObject {
    func onViewDidLoad()
    var delegate: SearchViewModelDelegate? { get set }
    func getFilteredRestaurantList() -> [RestaurantListCellModel]
    func getFilteredCuisineList() -> [CuisineListCellModel]
    func onTextFieldValueDidChanged(text: String)
    func onRestaurantListCellDidTapped(restaurantCellModel: RestaurantListCellModel)
}

protocol SearchViewModelDelegate: AnyObject {
    func setupView()
    func reloadData()
    func navigateToRestaurantPage(restaurantData: RestaurantData)
}

class SearchViewModel: SearchViewModelProtocol {
    weak var delegate: SearchViewModelDelegate?
    
    private var restaurantList: [RestaurantListCellModel] {
        return RestaurantListFetcher.shared.convertRestaurantListToRestaurantListCell()
    }
    private var cuisineList: [CuisineListCellModel] {
        return RestaurantListFetcher.shared.convertCuisineList()
    }
    
    private var filteredRestaurantList: [RestaurantListCellModel] = []
    private var filteredCuisineList: [CuisineListCellModel] = []
    
    func onViewDidLoad() {
        delegate?.setupView()
    }
    
    func getFilteredRestaurantList() -> [RestaurantListCellModel] {
        return filteredRestaurantList
    }
    
    func getFilteredCuisineList() -> [CuisineListCellModel] {
        return filteredCuisineList
    }
    
    func onTextFieldValueDidChanged(text: String) {
        if text.isEmpty {
            resetFilteredList()
        }
        else {
            //logic search
            filterRestaurantList(text: text)
            filterCuisineList(text: text)
            delegate?.reloadData()
        }
    }
    
    func onRestaurantListCellDidTapped(restaurantCellModel: RestaurantListCellModel) {
        if let restaurantData = RestaurantListFetcher.shared.restaurantData?.filter({ $0.name == restaurantCellModel.restaurantName }).first {
            delegate?.navigateToRestaurantPage(restaurantData: restaurantData)
        }
    }
    
}

private extension SearchViewModel {
    func resetFilteredList() {
        filteredCuisineList = []
        filteredRestaurantList = []
        delegate?.reloadData()
    }
    
    func filterRestaurantList(text: String) {
        let newFilteredRestaurantList = restaurantList.filter({ $0.cuisineName.lowercased().contains(text.lowercased()) || $0.restaurantName.lowercased().contains(text.lowercased()) })
        filteredRestaurantList = newFilteredRestaurantList
    }
    
    func filterCuisineList(text: String) {
        let newFilteredCuisineList = cuisineList.filter({ $0.cuisineName.lowercased().contains(text.lowercased()) })
        filteredCuisineList = newFilteredCuisineList
    }
}
