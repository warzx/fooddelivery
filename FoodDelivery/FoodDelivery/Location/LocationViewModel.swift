//
//  LocationViewModel.swift
//  FoodDelivery
//
//  Created by William on 18/6/24.
//

import CoreLocation
import Foundation
import MapKit

protocol LocationViewModelProtocol: AnyObject {
    func onViewDidLoad()
    var delegate: LocationViewModelDelegate? { get set }
    func getLocationList() -> [LocationCellModel]
    func onSearchTextFieldValueDidChanged(text: String)
    func onLocationCellDidTapped(index: Int)
    func onMapViewDidChangeState(annotation: MKPointAnnotation)
    func onSetLocationButtonDidTapped()
}

protocol LocationViewModelDelegate: AnyObject {
    func setupView()
    func updateMapRegion(region: MKCoordinateRegion)
    func setAnnotation(coordinate: CLLocationCoordinate2D,
                       title: String?,
                       subtitle: String?)
    func reloadData()
    func popVC()
}

protocol LocationViewModelAction: AnyObject {
    func onLocationPageDidPopped()
}

class LocationViewModel: NSObject, LocationViewModelProtocol {
    private let locationManager: CLLocationManager = CLLocationManager()
    
    weak var delegate: LocationViewModelDelegate?
    weak var action: LocationViewModelAction?
    
    var locationCellList: [LocationCellModel] = []
    var searchLocationMapItem: [MKMapItem] = []
    
    var selectedLocation: SavedLocation?
    
    func onViewDidLoad() {
        delegate?.setupView()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        setupSavedLocation()
    }
    
    func getLocationList() -> [LocationCellModel] {
        return locationCellList
    }
    
    func onSearchTextFieldValueDidChanged(text: String) {
        if text.isEmpty {
            locationCellList = []
            delegate?.reloadData()
        }
        else {
            //fetch location
            fetchLocationSearch(text: text)
        }
    }
    
    func onLocationCellDidTapped(index: Int) {
        updateSelectedLocation(coordinate: searchLocationMapItem[index].placemark.coordinate,
                               title: searchLocationMapItem[index].placemark.name,
                               subtitle: searchLocationMapItem[index].placemark.title)
        delegate?.setAnnotation(coordinate: searchLocationMapItem[index].placemark.coordinate,
                                title: searchLocationMapItem[index].placemark.name,
                                subtitle: searchLocationMapItem[index].placemark.title)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: searchLocationMapItem[index].placemark.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        delegate?.updateMapRegion(region: region)
    }
    
    func onMapViewDidChangeState(annotation: MKPointAnnotation) {
        reverseGeocodeCoordinate(annotation.coordinate) { title, subtitle in
            self.updateSelectedLocation(coordinate: annotation.coordinate,
                                        title: title,
                                        subtitle: subtitle)
            annotation.title = title
            annotation.subtitle = subtitle
        }
    }
    
    func onSetLocationButtonDidTapped() {
        guard let selectedLocation else { return }
        //save location to local
        SavedLocationService.shared.saveLocation(savedLocation: selectedLocation)
        
        //pop location view controller
        delegate?.popVC()
        action?.onLocationPageDidPopped()
    }
}

private extension LocationViewModel {
    func fetchLocationSearch(text: String) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = text
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { [weak self] response, error in
            guard let self else { return }
            if let response {
                self.searchLocationMapItem = response.mapItems
                self.convertMapItemsToListOfCellModel(mapItems: response.mapItems)
                self.delegate?.reloadData()
            }
            else if let error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func convertMapItemsToListOfCellModel(mapItems: [MKMapItem]) {
        var listCell: [LocationCellModel] = []
        for mapItem in mapItems {
            let cellModel: LocationCellModel = LocationCellModel(locationName: mapItem.placemark.name ?? "", locationDetails: mapItem.placemark.title ?? "")
            listCell.append(cellModel)
        }
        locationCellList = listCell
    }
    
    func setupSavedLocation() {
        guard let savedLocation: SavedLocation = SavedLocationService.shared.getSavedLocation() else {
            return
        }
        let cellModel: LocationCellModel = LocationCellModel(locationName: savedLocation.locationName, locationDetails: savedLocation.locationDetails)
        locationCellList = [cellModel]
        delegate?.reloadData()
    }
    
    func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D, completion: @escaping (String?, String?) -> Void) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Reverse geocoding error: \(error.localizedDescription)")
                completion(nil, nil)
                return
            }
            
            if let placemark = placemarks?.first {
                var addressString = ""
                var nameString = ""
                
                if let name = placemark.name {
                    addressString += name + ", "
                    nameString = name
                }
                if let locality = placemark.locality {
                    addressString += locality + ", "
                }
                if let administrativeArea = placemark.administrativeArea {
                    addressString += administrativeArea + ", "
                }
                if let postalCode = placemark.postalCode {
                    addressString += postalCode + ", "
                }
                if let country = placemark.country {
                    addressString += country
                }
                if nameString.isEmpty {
                    nameString = addressString
                }
                completion(nameString, addressString)
            } else {
                completion(nil, nil)
            }
        }
    }
    
    func updateSelectedLocation(coordinate: CLLocationCoordinate2D,
                                title: String?,
                                subtitle: String?) {
        selectedLocation = SavedLocation(latitude: coordinate.latitude, longitude: coordinate.longitude, locationName: title ?? "", locationDetails: subtitle ?? "")
    }
}

extension LocationViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        //set current location ke MKMapView
        let region: MKCoordinateRegion = MKCoordinateRegion(center: currentLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        //set pin di user location
        //reverse geocode
        reverseGeocodeCoordinate(currentLocation.coordinate) { title, subtitle in
            self.updateSelectedLocation(coordinate: currentLocation.coordinate,
                                        title: title,
                                        subtitle: subtitle)
            self.delegate?.setAnnotation(coordinate: currentLocation.coordinate,
                                         title: title,
                                         subtitle: subtitle)
        }
        delegate?.updateMapRegion(region: region)
        locationManager.stopUpdatingLocation()
    }
}
