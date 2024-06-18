//
//  MenuDetailViewController.swift
//  FoodDelivery
//
//  Created by William on 17/6/24.
//

import UIKit

class MenuDetailViewController: UIViewController {
    
    private lazy var menuImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .gray
        
        return imageView
    }()
    
    private lazy var menuLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 24.0, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var menuDescriptionLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var menuPriceLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var notesLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Notes"
        return label
    }()
    
    private lazy var notesTextView: UITextView = {
        let textView: UITextView = UITextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 16.0)
        textView.layer.cornerRadius = 6.0
        textView.layer.masksToBounds = true
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.black.cgColor
        return textView
    }()
    
    private lazy var totalQtyLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Total Quantity"
        return label
    }()
    
    private lazy var stepperView: MenuQtyStepperView = {
        let stepperView: MenuQtyStepperView = MenuQtyStepperView(frame: .zero)
        stepperView.translatesAutoresizingMaskIntoConstraints = false
        stepperView.delegate = self
        return stepperView
    }()
    
    private lazy var addToCartButton: UIButton = {
        let button: UIButton = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 6.0
        button.layer.masksToBounds = true
        button.setTitle("Checkout", for: .normal)
        button.backgroundColor = .gray
        button.tintColor = .systemOrange
        button.addTarget(self, action: #selector(addToCartButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    let viewModel: MenuDetailViewModelProtocol
    
    init(viewModel: MenuDetailViewModel) {
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

private extension MenuDetailViewController {
    @objc
    func addToCartButtonDidTapped() {
        viewModel.onAddToCartButtonDidTapped(qty: stepperView.currentQty, notes: notesTextView.text)
    }
}

extension MenuDetailViewController: MenuDetailViewModelDelegate {
    func setupView() {
        view.backgroundColor = .white
        
        let separator: UIView = UIView(frame: .zero)
        separator.backgroundColor = .black
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomSeparator: UIView = UIView(frame: .zero)
        bottomSeparator.backgroundColor = .black
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(menuImageView)
        view.addSubview(menuLabel)
        view.addSubview(menuDescriptionLabel)
        view.addSubview(menuPriceLabel)
        view.addSubview(separator)
        view.addSubview(notesLabel)
        view.addSubview(notesTextView)
        view.addSubview(bottomSeparator)
        view.addSubview(totalQtyLabel)
        view.addSubview(stepperView)
        view.addSubview(addToCartButton)
        
        NSLayoutConstraint.activate([
            menuImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            
            menuLabel.topAnchor.constraint(equalTo: menuImageView.bottomAnchor, constant: 16.0),
            menuLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            
            menuDescriptionLabel.topAnchor.constraint(equalTo: menuLabel.bottomAnchor, constant: 8.0),
            menuDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            
            menuPriceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            menuPriceLabel.centerYAnchor.constraint(equalTo: menuLabel.bottomAnchor),
            menuPriceLabel.leadingAnchor.constraint(greaterThanOrEqualTo: menuLabel.trailingAnchor, constant: 16.0),
            menuPriceLabel.leadingAnchor.constraint(greaterThanOrEqualTo: menuDescriptionLabel.trailingAnchor, constant: 16.0),
            menuPriceLabel.widthAnchor.constraint(equalToConstant: 100.0),
            
            separator.topAnchor.constraint(equalTo: menuDescriptionLabel.bottomAnchor, constant: 16.0),
            separator.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            separator.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            separator.heightAnchor.constraint(equalToConstant: 1.0),
            
            notesLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 16.0),
            notesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            notesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            
            notesTextView.topAnchor.constraint(equalTo: notesLabel.bottomAnchor, constant: 8.0),
            notesTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            notesTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            notesTextView.heightAnchor.constraint(equalToConstant: 60.0),
            
            bottomSeparator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSeparator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSeparator.heightAnchor.constraint(equalToConstant: 1.0),
            
            totalQtyLabel.topAnchor.constraint(equalTo: bottomSeparator.bottomAnchor, constant: 8.0),
            totalQtyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            
            stepperView.topAnchor.constraint(equalTo: bottomSeparator.bottomAnchor, constant: 8.0),
            stepperView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            
            addToCartButton.topAnchor.constraint(equalTo: totalQtyLabel.bottomAnchor, constant: 8.0),
            addToCartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16.0),
            addToCartButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            addToCartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0)
        ])
        
    }
    
    func configureView(with menuOrder: MenuOrder) {
        if let imageURL = URL(string: menuOrder.menu.imageURL) {
            menuImageView.load(url: imageURL)
        }
        menuLabel.text = menuOrder.menu.name
        menuDescriptionLabel.text = menuOrder.menu.description
        menuPriceLabel.text = "Rp. \(menuOrder.menu.price)"
        stepperView.currentQty = menuOrder.qty
        notesTextView.text = menuOrder.notes
    }
    
    func updateButtonText(text: String) {
        addToCartButton.setTitle(text, for: .normal)
    }
    
    func dismissModal(completion: @escaping () -> Void) {
        dismiss(animated: true, completion: completion)
    }
}

extension MenuDetailViewController: MenuQtyStepperViewDelegate {
    func onDecreaseButtonDidTapped() {
        viewModel.onDecreaseButtonDidTapped(qty: stepperView.currentQty)
    }
    
    func onIncreaseButtonDidTapped() {
        viewModel.onIncreaseButtonDidTapped(qty: stepperView.currentQty)
    }
}
