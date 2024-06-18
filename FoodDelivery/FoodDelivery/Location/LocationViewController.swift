//
//  LocationViewController.swift
//  FoodDelivery
//
//  Created by William on 18/6/24.
//

import MapKit
import UIKit

class LocationViewController: UIViewController {
    
    private lazy var mapView: MKMapView = {
        let mapView: MKMapView = MKMapView(frame: .zero)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        return mapView
    }()
    
    private lazy var searchTextField: UISearchTextField = {
        let textField: UISearchTextField = UISearchTextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(searchTextFieldValueDidChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var tableView: UITableView = {
        let tableView: UITableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(LocationCell.self, forCellReuseIdentifier: "location")
        return tableView
    }()
    
    private lazy var setLocationButton: UIButton = {
        let button: UIButton = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 6.0
        button.layer.masksToBounds = true
        button.setTitle("Set Location", for: .normal)
        button.backgroundColor = .gray
        button.tintColor = .systemOrange
        button.addTarget(self, action: #selector(setLocationButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    let viewModel: LocationViewModelProtocol
    
    init(viewModel: LocationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onViewDidLoad()
    }

}

private extension LocationViewController {
    @objc 
    func searchTextFieldValueDidChanged() {
        viewModel.onSearchTextFieldValueDidChanged(text: searchTextField.text ?? "")
    }
    
    @objc
    func setLocationButtonDidTapped() {
        viewModel.onSetLocationButtonDidTapped()
    }
}

extension LocationViewController: LocationViewModelDelegate {
    func setupView() {
        view.backgroundColor = .white
        title = "Set Location"
        
        view.addSubview(mapView)
        view.addSubview(searchTextField)
        view.addSubview(tableView)
        view.addSubview(setLocationButton)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.heightAnchor.constraint(equalTo: mapView.widthAnchor),
            
            searchTextField.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 16.0),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            
            tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 16.0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            setLocationButton.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            setLocationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            setLocationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            setLocationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16.0)
        ])
    }
    
    func updateMapRegion(region: MKCoordinateRegion) {
        mapView.setRegion(region, animated: true)
    }
    
    func setAnnotation(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        let annotation: MKPointAnnotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title //nama tempat
        annotation.subtitle = subtitle //nama jalan
        if let existingAnnotation = mapView.annotations.first {
            mapView.removeAnnotation(existingAnnotation)
        }
        mapView.addAnnotation(annotation)
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func popVC() {
        navigationController?.popViewController(animated: true)
    }
}

extension LocationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        let identifier: String = "draggablePin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.isDraggable = true
            annotationView?.canShowCallout = true
        }
        else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        //hasil drag
        if newState == .ending {
            if let annotation = view.annotation as? MKPointAnnotation {
                viewModel.onMapViewDidChangeState(annotation: annotation)
            }
        }
    }
}

extension LocationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getLocationList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "location") as? LocationCell else {
            return UITableViewCell()
        }
        cell.setupCellModel(cellModel: viewModel.getLocationList()[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.onLocationCellDidTapped(index: indexPath.row)
    }
    
}
