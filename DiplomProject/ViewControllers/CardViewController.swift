//
//  CardViewController.swift
//  DiplomProject
//
//  Created by Денис Хафизов on 05.02.2024.
//

import UIKit

class CardViewController: UIViewController {
    
    var positions: [Position] = []
    
    private let tableView = UITableView()
    
    private let orderButton = UIButton(title: "Заказать", titleColor: .white, backgroundColor: .mainDark())
    private let denyButton = UIButton(title: "Отменить", titleColor: .white, backgroundColor: .mainRed())
    
    private let nameTitleLabel = UILabel(text: "Название", textAlignment: .center)
    private let countTitleLabel = UILabel(text: "Кол-во", textAlignment: .center)
    private let sizeTitleLabel = UILabel(text: "Размер", textAlignment: .center)
    private let costTitleLabel = UILabel(text: "Цена", textAlignment: .center)
    
    private let titleStackView = UIStackView()
    private let buttonsStackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupView()
        addSubViews()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        positions = StorageManager.shared.fetchPositions()
        tableView.reloadData()
    }
    
    private func setupUI() {
        title = "Корзина"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 35
        tableView.register(PositionTableViewCell.self, forCellReuseIdentifier: PositionTableViewCell.reuseId)
        
        denyButton.addTarget(self, action: #selector(denyButtonTapped), for: .touchUpInside)
        orderButton.addTarget(self, action: #selector(orderButtonTapped), for: .touchUpInside)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        
        present(alert, animated: true)
    }
    
    @objc
    private func denyButtonTapped() {
        positions = StorageManager.shared.deletePositions()
        tableView.reloadData()
    }
    
    @objc
    private func orderButtonTapped() {
//        var order = Order(userID: AuthService.shared.currentUser?.uid ?? "", date: Date(), status: OrderStatus.new.rawValue)
//        order.positions = positions
//        DataBaseService.shared.createOrder(order: order) { result in
//            switch result {
//            case .success(let order):
//                print(order.cost)
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//        
//        positions = StorageManager.shared.deletePositions()
//        tableView.reloadData()
//        
//        showAlert(title: "Заказ создан", message: "Вы можете посмотреть его статус в своем профиле.")
        
        let confirmOrderVC = ConfirmOrderViewController()
        confirmOrderVC.getPositions(positions: positions)
        present(confirmOrderVC, animated: true)
    }
}

// MARK: Settings View
extension CardViewController {
    func setupView() {
        view.backgroundColor = .white
    }
}

// MARK: Setting
extension CardViewController {
    func addSubViews() {
        [
            titleStackView,
            buttonsStackView,
            tableView
        ].forEach {
            view.addSubview($0)
        }
        
        titleStackView.addArrangedSubview(nameTitleLabel)
        titleStackView.addArrangedSubview(countTitleLabel)
        titleStackView.addArrangedSubview(sizeTitleLabel)
        titleStackView.addArrangedSubview(costTitleLabel)
        titleStackView.axis = .horizontal
        titleStackView.distribution = .fillEqually
        titleStackView.spacing = 0
        
        buttonsStackView.addArrangedSubview(orderButton)
        buttonsStackView.addArrangedSubview(denyButton)
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.spacing = 16
    }
}

// MARK: Layout
extension CardViewController {
    func setupLayout() {
        [
            nameTitleLabel,
            countTitleLabel,
            sizeTitleLabel,
            costTitleLabel,
            titleStackView,
            orderButton,
            denyButton,
            buttonsStackView,
            tableView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            buttonsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor)
        ])
    }
}

//MARK: TableViewDataSource
extension CardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        positions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PositionTableViewCell.reuseId, for: indexPath) as? PositionTableViewCell else { return UITableViewCell() }
        cell.configure(
            name: positions[indexPath.row].product.titile,
            count: positions[indexPath.row].count, 
            size: positions[indexPath.row].size,
            cost: positions[indexPath.row].cost
        )
        
        return cell
    }
}

//MARK: TableViewDelegate
extension CardViewController: UITableViewDelegate {
    
}
