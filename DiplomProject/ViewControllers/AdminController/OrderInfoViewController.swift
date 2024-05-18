//
//  OrderInfoViewController.swift
//  DiplomProject
//
//  Created by Денис Хафизов on 23.02.2024.
//

import UIKit

final class OrderInfoViewController: UIViewController {
    
    private var user = Profile(id: "", name: "", phone: "", address: "")
    private var order = Order(userID: "", date: Date(), status: "", paymentMethod: "")
    
    private let userNameLabel = UILabel(text: "", labelFont: .boldSystemFont(ofSize: 20))
    private let userAddressLabel = UILabel(text: "")
    private let userPhoneLabel = UILabel(text: "")
    
    private let orderStatusLabel = UILabel(text: "Статус заказа:")
    private let changeStatusButton = UIButton(title: "", titleColor: .white, backgroundColor: .mainDark())
    
    private let stackView = UIStackView()
    
    private var statusChangeMenu = UIMenu(title: "Статус")
    
    private let positionsTableView = UITableView()
    
    var statuses: [String] {
        var sts = [String]()
        
        for status in OrderStatus.allCases {
            sts.append(status.rawValue)
        }
        return sts
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        addSubview()
        setupLayout()
        
        getUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeStatusButton.setTitle(order.status, for: .normal)
    }
    
    private func getUser() {
        DataBaseService.shared.getProfile(userID: order.userID) { result in
            switch result {
            case .success(let user):
                self.user = user
                self.setupData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getOrder(order: Order) {
        self.order = order
    }
    
    private func setupData() {
        userNameLabel.text = "Имя клиента: \(user.name)"
        userAddressLabel.text = "Адрес клиента: \(user.address)"
        userPhoneLabel.text = "Номер телефона: \(user.phone)"
    }
    
    private func setupStatusMenu() {
        let new = UIAction(title: "Новый") { [unowned self] _ in
            changeStatusButton.setTitle(statuses[0], for: .normal)
            setOrder(status: statuses[0])
        }
        let cooking = UIAction(title: "Готовится") { [unowned self] _ in
            changeStatusButton.setTitle(statuses[1], for: .normal)
            setOrder(status: statuses[1])
        }
        let delivery = UIAction(title: "Доставляется") { [unowned self] _ in
            changeStatusButton.setTitle(statuses[2], for: .normal)
            setOrder(status: statuses[2])
        }
        let completed = UIAction(title: "Выполнен") { [unowned self] _ in
            changeStatusButton.setTitle(statuses[3], for: .normal)
            setOrder(status: statuses[3])
        }
        let cancelled = UIAction(title: "Отменен") { [unowned self] _ in
            changeStatusButton.setTitle(statuses[4], for: .normal)
            setOrder(status: statuses[4])
        }
        statusChangeMenu = UIMenu(title: "Статус", children: [new, cooking, delivery, completed, cancelled])
        changeStatusButton.menu = statusChangeMenu
        changeStatusButton.showsMenuAsPrimaryAction = true
    }
    
    private func setOrder(status: String) {
        order.status = status
        DataBaseService.shared.createOrder(order: order) { result in
            switch result {
            case .success(let success):
                print(success.status)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}

//MARK: Setting view
private extension OrderInfoViewController {
    func setupView() {
        view.backgroundColor = .white
        
        positionsTableView.delegate = self
        positionsTableView.dataSource = self
        positionsTableView.register(OrderTableViewCell.self, forCellReuseIdentifier: OrderTableViewCell.reuseId)
    }
}

//MARK: Setting
private extension OrderInfoViewController {
    func addSubview() {
        [
            stackView,
            positionsTableView
        ].forEach {
            view.addSubview($0)
        }
    
        setupStatusMenu()
        let orderStatusStackView = UIStackView(arrangedSubviews: [orderStatusLabel, changeStatusButton])
        orderStatusStackView.axis = .horizontal
        orderStatusStackView.spacing = 20
        orderStatusStackView.distribution = .fillProportionally
        
        stackView.addArrangedSubview(userNameLabel)
        stackView.addArrangedSubview(userAddressLabel)
        stackView.addArrangedSubview(userPhoneLabel)
        stackView.addArrangedSubview(orderStatusStackView)
        stackView.axis = .vertical
        stackView.spacing = 5
    }
}

//MARK: Layout
private extension OrderInfoViewController {
    func setupLayout() {
        [
            stackView,
            positionsTableView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            positionsTableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            positionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            positionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            positionsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension OrderInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return order.positions.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = positionsTableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.reuseId, for: indexPath) as? OrderTableViewCell else { return UITableViewCell() }
            cell.configure(
                name: order.positions[indexPath.row].product.titile,
                count: String(order.positions[indexPath.row].count),
                size: order.positions[indexPath.row].size,
                cost: order.positions[indexPath.row].cost
            )
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.reuseId, for: indexPath)
            cell.textLabel?.text = "Итог: \(order.cost) рублей."
            return cell
        }

    }
}
