//
//  ConfirmOrderViewController.swift
//  DiplomProject
//
//  Created by Денис Хафизов on 20.04.2024.
//

import UIKit

final class ConfirmOrderViewController: UIViewController {
    
    private var user = Profile(id: "", name: "", phone: "", address: "")
    private var order = Order(userID: "", date: Date(), status: "", paymentMethod: "")
    private var positions = [Position]()
    
    private let userNameLabel = UILabel(text: "", labelFont: .boldSystemFont(ofSize: 20))
    private let userAddressLabel = UILabel(text: "")
    private let userPhoneLabel = UILabel(text: "")
    
    private let paymentMethodLabel = UILabel(text: "Способ оплаты:")
    private var paymentMethodMenu = UIMenu(title: "Способ оплаты:")
    private let paymentMethodButton = UIButton(title: "не выбран", titleColor: .white, backgroundColor: .mainDark())
    private var paymentMethod = ""
    var statuses: [String] {
        var sts = [String]()
        
        for status in PaymentMethod.allCases {
            sts.append(status.rawValue)
        }
        return sts
    }
    
    private let stackView = UIStackView()
        
    private let positionsTableView = UITableView()
    private let orderButton = UIButton(title: "Заказать", titleColor: .white, backgroundColor: .mainDark())
        
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        addSubview()
        setupLayout()
        
        getUser()
    }
    
    private func getUser() {
        DataBaseService.shared.getProfile() { result in
            switch result {
            case .success(let user):
                self.user = user
                self.setupData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getPositions(positions: [Position]) {
        order.positions = positions
        self.positions = positions
    }
    
    private func setupData() {
        userNameLabel.text = "Имя клиента: \(user.name)"
        userAddressLabel.text = "Адрес клиента: \(user.address)"
        userPhoneLabel.text = "Номер телефона: \(user.phone)"
    }
        
    private func setOrder() {
        order = Order(userID: AuthService.shared.currentUser?.uid ?? "", date: Date(), status: OrderStatus.new.rawValue, paymentMethod: paymentMethod)
        order.positions = positions
        DataBaseService.shared.createOrder(order: order) { result in
            switch result {
            case .success(_):
                self.showAlert(
                    title: "Заказ создан.",
                    message: "Вы можете посмотреть его статус в своем профиле.",
                    closeView: true
                )
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
        self.order.positions = StorageManager.shared.deletePositions()
    }
    
    private func setupStatusMenu() {
        let cash = UIAction(title: "Наличными при получении") { [unowned self] _ in
            paymentMethodButton.setTitle(statuses[0], for: .normal)
            paymentMethod = statuses[0]
        }
        let card = UIAction(title: "Картой при получении") { [unowned self] _ in
            paymentMethodButton.setTitle(statuses[1], for: .normal)
            paymentMethod = statuses[1]
        }
        paymentMethodMenu = UIMenu(title: "Статус", children: [cash, card])
        paymentMethodButton.menu = paymentMethodMenu
        paymentMethodButton.showsMenuAsPrimaryAction = true
    }
    
    private func showAlert(title: String, message: String, closeView: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
            if closeView {
                dismiss(animated: true)
            }
        }
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }

    @objc
    private func orderButtonPressed() {
        guard user.name != "", user.address != "", user.phone != "" else {
            showAlert(
                title: "Неверные данные пользователя.",
                message: "Вы не указали данные для получения заказа. Пожалуйста, перейдите в профиль и заполните все данные.",
                closeView: false
            )
            return
        }
        guard paymentMethod != "" else {
            showAlert(
                title: "Не выбран способ оплаты.",
                message: "Вы не указали способ оплаты.",
                closeView: false
            )
            return
        }
        setOrder()
    }
}

//MARK: Setting view
private extension ConfirmOrderViewController {
    func setupView() {
        view.backgroundColor = .white
        
        positionsTableView.delegate = self
        positionsTableView.dataSource = self
        positionsTableView.register(OrderTableViewCell.self, forCellReuseIdentifier: OrderTableViewCell.reuseId)
        orderButton.addTarget(self, action: #selector(orderButtonPressed), for: .touchUpInside)
    }
}

//MARK: Setting
private extension ConfirmOrderViewController {
    func addSubview() {
        [
            stackView,
            positionsTableView,
            orderButton
        ].forEach {
            view.addSubview($0)
        }
        
        setupStatusMenu()
        let paymentMethodStackView = UIStackView(arrangedSubviews: [paymentMethodLabel, paymentMethodButton])
        paymentMethodStackView.axis = .horizontal
        paymentMethodStackView.spacing = 20
        paymentMethodStackView.distribution = .fillProportionally
        
        stackView.addArrangedSubview(userNameLabel)
        stackView.addArrangedSubview(userAddressLabel)
        stackView.addArrangedSubview(userPhoneLabel)
        stackView.addArrangedSubview(paymentMethodStackView)
        stackView.axis = .vertical
        stackView.spacing = 5
    }
}

//MARK: Layout
private extension ConfirmOrderViewController {
    func setupLayout() {
        [
            stackView,
            positionsTableView,
            orderButton
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
            positionsTableView.bottomAnchor.constraint(equalTo: orderButton.topAnchor, constant: 16),
            
            orderButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            orderButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            orderButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension ConfirmOrderViewController: UITableViewDelegate, UITableViewDataSource {
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

