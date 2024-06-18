//
//  HomeViewModel.swift
//  FoodDelivery
//
//  Created by William on 13/6/24.
//

import Foundation

protocol HomeViewModelProtocol: AnyObject {
    func onViewDidLoad()
    var delegate: HomeViewModelDelegate? { get set }
    func getRestaurantList() -> [RestaurantListCellModel]
    func getCuisineList() -> [CuisineListCellModel]
    func onRestaurantListCellDidTapped(restaurantCellModel: RestaurantListCellModel)
    func onSetLocationButtonDidTapped()
    func onLocationPageDidPopped()
}

protocol HomeViewModelDelegate: AnyObject {
    func setupView()
    func reloadData()
    func navigateToRestaurantPage(restaurantData: RestaurantData)
    func navigateToLocationPage()
    func updateSetLocationButton(title: String)
}

class HomeViewModel: HomeViewModelProtocol {
    weak var delegate: HomeViewModelDelegate?
    
    private var restaurantCellModelList: [RestaurantListCellModel] = []
    private var cuisineList: [CuisineListCellModel] = []
    
    func onViewDidLoad() {
        delegate?.setupView()
        fetchRestaurantList()
        setupSetLocationButtonTitle()
    }
    
    func getRestaurantList() -> [RestaurantListCellModel] {
        return restaurantCellModelList
    }
    
    func getCuisineList() -> [CuisineListCellModel] {
        return cuisineList
    }
    
    func onRestaurantListCellDidTapped(restaurantCellModel: RestaurantListCellModel) {
        if let restaurantData = RestaurantListFetcher.shared.restaurantData?.filter({ $0.name == restaurantCellModel.restaurantName }).first {
            delegate?.navigateToRestaurantPage(restaurantData: restaurantData)
        }
    }
    
    func onSetLocationButtonDidTapped() {
        delegate?.navigateToLocationPage()
    }
    
    func onLocationPageDidPopped() {
        setupSetLocationButtonTitle()
    }
}

private extension HomeViewModel {
    func fetchRestaurantList() {
        RestaurantListFetcher.shared.requestRestaurantList { [weak self] restaurantList, error in
            guard let self else { return }
            if let restaurantList, !restaurantList.isEmpty {
                self.restaurantCellModelList = RestaurantListFetcher.shared.convertRestaurantListToRestaurantListCell()
                self.cuisineList = RestaurantListFetcher.shared.convertCuisineList()
                self.delegate?.reloadData()
            }
            else if let error {
                //handle error
            }
            
        }
    }
    
    func setupSetLocationButtonTitle() {
        guard let savedLocation = SavedLocationService.shared.getSavedLocation() else {
            return
        }
        delegate?.updateSetLocationButton(title: savedLocation.locationName)
    }
}
