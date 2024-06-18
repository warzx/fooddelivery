//
//  RestaurantListFetcher.swift
//  FoodDelivery
//
//  Created by William on 15/6/24.
//

import Foundation

class RestaurantListFetcher {
    
    static let shared = RestaurantListFetcher()
    
    var restaurantData: [RestaurantData]?
    
    func requestRestaurantList(completionBlock: @escaping ([RestaurantData]?, Error?) -> Void) {
        guard let url: URL = URL(string: "https://restaurant-api-f0974-default-rtdb.firebaseio.com/restaurants.json") else {
            completionBlock(nil, NSError(domain: "Invalid URL", code: -1))
            return
        }
        let urlRequest: URLRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error {
                completionBlock(nil, error)
                return
            }
            
            guard let data = data else {
                completionBlock(nil, NSError(domain: "Data invalid", code: -2))
                return
            }
            
            //decode json
            do {
                let decoder = JSONDecoder()
                let restaurants = try decoder.decode([RestaurantData].self, from: data)
                self.restaurantData = restaurants
                completionBlock(restaurants, nil)
            } catch {
                completionBlock(nil, error)
            }
        }
        task.resume()
    }
    
    func convertRestaurantListToRestaurantListCell() -> [RestaurantListCellModel] {
        guard let restaurantData else { return [] }
        var restaurantCellList: [RestaurantListCellModel] = []
        for restaurant in restaurantData {
            let restaurantListCellModel: RestaurantListCellModel = RestaurantListCellModel(restaurantImageURL: restaurant.imageURL, restaurantName: restaurant.name, cuisineName: restaurant.cuisine)
            restaurantCellList.append(restaurantListCellModel)
        }
        return restaurantCellList
    }
    
    func convertCuisineList() -> [CuisineListCellModel] {
        guard let restaurantData else { return [] }
        var cuisineCellList: [CuisineListCellModel] = []
        for restaurant in restaurantData {
            let cuisineModel: CuisineListCellModel = CuisineListCellModel(cuisineImageURL: restaurant.cuisineImageURL, cuisineName: restaurant.cuisine)
            if cuisineCellList.filter({ $0.cuisineName == restaurant.cuisine }).isEmpty {
                //belum ada yang sama, menghindari duplicate data
                cuisineCellList.append(cuisineModel)
            }
        }
        return cuisineCellList
    }
}
