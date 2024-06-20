//
//  AdminViewController.swift
//  DiplomProject
//
//  Created by Денис Хафизов on 20.02.2024.
//

import UIKit

final class AdminViewController: UIViewController {
    
    private var orders = [Order]()
    private var newOrders = [Order]()
    private var cookingOrders = [Order]()
    private var deliveryOrders = [Order]()
    private var completedOrders = [Order]()
    private var cancelledOrders = [Order]()
    
    private var positions = [Position]()
    
    private let ordersTableView = UITableView()
    
    private var reloadButton = UIBarButtonItem()
    private var signOutButton = UIBarButtonItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        addSubViews()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getOrders()
    }
    
    private func getOrders() {
        DataBaseService.shared.getOrders(userID: nil) { [weak self] result in
            switch result {
            case .success(let orders):
                self?.orders = orders
                
                for orderIndex in 0..<orders.count {
                    self?.getPositions(orderID: orders[orderIndex].id, orderIndex: orderIndex)
                }
                self?.filterOrders()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func getPositions(orderID: String, orderIndex: Int) {
        DataBaseService.shared.getPositions(orderID: orderID) { [weak self] result in
            switch result {
            case .success(let positions):
                self?.orders[orderIndex].positions = positions
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func filterOrders() {
        newOrders = []
        cookingOrders = []
        deliveryOrders = []
        completedOrders = []
        cancelledOrders = []
        
        for order in orders {
            switch order.status {
            case "Новый":
                newOrders.append(order)
            case "Готовится":
                cookingOrders.append(order)
            case "Доставляется":
                deliveryOrders.append(order)
            case "Выполнен":
                completedOrders.append(order)
            case "Отменен":
                cancelledOrders.append(order)
            default:
                break
            }
        }
        ordersTableView.reloadData()
    }
    
    @objc
    private func reloadButtonPressed() {
        getOrders()
    }
    
    @objc
    private func signOutButtonPressed() {
        AuthService.shared.signOut()
        dismiss(animated: true)
    }
}

//MARK: Setting view
private extension AdminViewController {
    func setupView() {
        title = "Админ-панель"
        view.backgroundColor = .white
        
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
        ordersTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        reloadButton = UIBarButtonItem(title: "Обновить", style: .plain, target: self, action: #selector(reloadButtonPressed))
        navigationItem.rightBarButtonItem = reloadButton
        reloadButton.tintColor = .black
        
        signOutButton = UIBarButtonItem(title: "Выйти", style: .plain, target: self, action: #selector(signOutButtonPressed))
        navigationItem.leftBarButtonItem = signOutButton
        signOutButton.tintColor = .black
    }
}

//MARK: Setting
private extension AdminViewController {
    func addSubViews() {
        [
            ordersTableView
        ].forEach {
            view.addSubview($0)
        }
    }
}

//MARK: Layout
private extension AdminViewController {
    func setupLayout() {
        [
            ordersTableView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            ordersTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            ordersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            ordersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            ordersTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK: Table View DataSource
extension AdminViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return newOrders.count
        case 1:
            return cookingOrders.count
        case 2:
            return deliveryOrders.count
        case 3:
            return completedOrders.count
        case 4:
            return cancelledOrders.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = ordersTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = "Заказ от: \(dateFormatter.string(from: newOrders[indexPath.row].date))"
        case 1:
            cell.textLabel?.text = "Заказ от: \(dateFormatter.string(from: cookingOrders[indexPath.row].date))"
        case 2:
            cell.textLabel?.text = "Заказ от: \(dateFormatter.string(from: deliveryOrders[indexPath.row].date))"
        case 3:
            cell.textLabel?.text = "Заказ от: \(dateFormatter.string(from: completedOrders[indexPath.row].date))"
        case 4:
            cell.textLabel?.text = "Заказ от: \(dateFormatter.string(from: cancelledOrders[indexPath.row].date))"
        default:
            cell.textLabel?.text = ""

        }
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Новый"
        case 1:
            return "Готовится"
        case 2:
            return "Доставляется"
        case 3:
            return "Выполнен"
        case 4:
            return "Отменен"
        default:
            return ""
        }
    }
    
//    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        switch section {
//        case 0:
//            return "Итог: \(newOrders[section].cost)"
//        case 1:
//            return "Итог: \(cookingOrders[section].cost)"
//        case 2:
//            return "Итог: \(deliveryOrders[section].cost)"
//        case 3:
//            return "Итог: \(completedOrders[section].cost)"
//        case 4:
//            return "Итог: \(cancelledOrders[section].cost)"
//        default:
//            return ""
//
//        }
//    }
}

//MARK:: Table View Delegate
extension AdminViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ordersInfo = OrderInfoViewController()
        ordersInfo.getOrder(order: orders[indexPath.section])
        present(UINavigationController(rootViewController: ordersInfo), animated: true)
        
        ordersTableView.deselectRow(at: indexPath, animated: true)
    }
    
}
