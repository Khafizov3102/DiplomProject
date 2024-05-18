//
//  ProductViewController.swift
//  DiplomProject
//
//  Created by Денис Хафизов on 31.01.2024.
//

import UIKit

final class ProductViewController: UIViewController {
    
    private var product = Product(id: "", titile: "", imageUrl: "", price: 0, description: "", isRecommend: false)
    
    let cardsVC = CardViewController()
    
    private let productImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.backgroundColor = .systemCyan
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let productNameLabel: UILabel = {
       let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    private let productDiscriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    private let productPriceLabel = UILabel(text: "")
    private let productCountLabel: UILabel = {
        let label = UILabel()
        label.text = "Количество: 1"
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 15)
        
        return label
    }()
    
    private let stackView = UIStackView()
    
    private let orderButton = UIButton(title: "Добавить", titleColor: .white, backgroundColor: .darkGray)
    
    private let sizeSegmentedControll: UISegmentedControl = {
        let segmentedControll = UISegmentedControl(items: ["Маленькая", "Средняя", "Большая"])
        segmentedControll.selectedSegmentIndex = -1
        return segmentedControll
    }()
    
    private let stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 1
        stepper.maximumValue = 10
        
        return stepper
    }()
    
    private let productCountStackView = UIStackView()
    
    private var size = ProductSize.small
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        addSubViews()
        setupLayout()
        setupUI()
    }
    
    private func setupUI() {
        orderButton.addTarget(self, action: #selector(orderButtonPressed), for: .touchUpInside)
        sizeSegmentedControll.addTarget(self, action: #selector(sizeSegmentedControllEditing), for: .valueChanged)
        stepper.addTarget(self, action: #selector(stepperEditing), for: .valueChanged)
    }
    
    func configure(product: Product) {
        self.product = product
        
        productImageView.image = UIImage(named: product.imageUrl)
        productNameLabel.text = product.titile
        productDiscriptionLabel.text = product.description
        productPriceLabel.text = "\(product.price)₽"
    }
    
    private func updatePrice() {
        switch sizeSegmentedControll.selectedSegmentIndex {
        case 1:
            productPriceLabel.text = "\(round(Double(product.price) * 1.15) * stepper.value)₽"
        case 2:
            productPriceLabel.text = "\(round(Double(product.price) * 1.3) * stepper.value)₽"
        default:
            productPriceLabel.text = "\(Double(product.price) * stepper.value)₽"
        }
        
        productCountLabel.text = "Количество: \(Int(stepper.value))"
    }
    
    @objc
    private func orderButtonPressed() {
        var size = ""
        switch sizeSegmentedControll.selectedSegmentIndex {
        case 1:
            size = ProductSize.medium.rawValue
        case 2:
            size = ProductSize.large.rawValue
        default:
            size = ProductSize.small.rawValue
        }
        StorageManager.shared.save(position: Position(id: UUID().uuidString, product: product, size: size, count: Int(stepper.value)))
        dismiss(animated: true)
    }
    
    @objc
    private func sizeSegmentedControllEditing() {
        updatePrice()
    }
    
    @objc
    private func stepperEditing() {
        updatePrice()
    }
}

// MARK: Settings View
private extension ProductViewController {
    func setupView() {
        view.backgroundColor = .white
    }
}

// MARK: Setting
private extension ProductViewController {
    func addSubViews() {
        [
            productImageView,
            stackView
        ].forEach {
            view.addSubview($0)
        }
        
        productCountStackView.addArrangedSubview(productCountLabel)
        productCountStackView.addArrangedSubview(stepper)
        productCountStackView.axis = .horizontal
        productCountStackView.distribution = .fill
        productCountStackView.spacing = 15
        
        stackView.addArrangedSubview(productNameLabel)
        stackView.addArrangedSubview(productDiscriptionLabel)
        stackView.addArrangedSubview(productCountStackView)
        stackView.addArrangedSubview(sizeSegmentedControll)
        stackView.addArrangedSubview(productPriceLabel)
        stackView.addArrangedSubview(orderButton)
        stackView.axis = .vertical
        stackView.spacing = 15
        
    }
}

// MARK: Layout
private extension ProductViewController {
    func setupLayout() {
        [
            productImageView,
            productNameLabel,
            productDiscriptionLabel,
            productPriceLabel,
            productCountStackView,
            stackView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            productImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}


