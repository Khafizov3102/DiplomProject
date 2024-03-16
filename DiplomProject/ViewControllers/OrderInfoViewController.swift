//
//  OrderInfoViewController.swift
//  DiplomProject
//
//  Created by Денис Хафизов on 23.02.2024.
//

import UIKit

final class OrderInfoViewController: UIViewController {
    
    private var user = Profile(id: "", name: "", phone: 0, address: "")
    private var order = Order(userID: "", date: Date(), status: "")
    
    private let userNameLabel: UILabel = {
       let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        
        return label
    }()
    private let userAddressLabel = UILabel(text: "")
    private let userPhoneLabel = UILabel(text: "")
    
    private let stackView = UIStackView()
    
    private let positionsTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        addSubview()
        setupLayout()
        
        getUser()
        
        setupData()
    }
    
    private func getUser() {
        DataBaseService.shared.getProfile(userID: order.userID) { result in
            switch result {
            case .success(let user):
                self.user = user
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getOrder(order: Order) {
        self.order = order
    }
    
    private func setupData() {
        userNameLabel.text = user.name
        userPhoneLabel.text = user.address
        userPhoneLabel.text = String(user.phone)
    }
}

//MARK: Setting view
private extension OrderInfoViewController {
    func setupView() {
        view.backgroundColor = .white
        
        userNameLabel.text = user.name
    }
}

//MARK: Setting
private extension OrderInfoViewController {
    func addSubview() {
        [
            stackView
        ].forEach {
            view.addSubview($0)
        }
        
        stackView.addArrangedSubview(userNameLabel)
        stackView.addArrangedSubview(userAddressLabel)
        stackView.addArrangedSubview(userPhoneLabel)
        stackView.axis = .vertical
        stackView.spacing = 10
    }
}

//MARK: Layout
private extension OrderInfoViewController {
    func setupLayout() {
        [
            stackView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
