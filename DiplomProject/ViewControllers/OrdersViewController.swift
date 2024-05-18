//
//  OrdersViewController.swift
//  DiplomProject
//
//  Created by Денис Хафизов on 19.02.2024.
//

import UIKit

final class OrdersViewController: UIViewController {
    
    private var orders = [Order]()
    private var positions = [Position]()
    
    private let ordersTableView = UITableView()
    
    private var reloadButton = UIBarButtonItem()

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
        DataBaseService.shared.getOrders(userID: AuthService.shared.currentUser?.uid) { result in
            switch result {
            case .success(let orders):
                self.orders = orders
                
                for orderIndex in 0..<orders.count {
                    self.getPositions(orderID: orders[orderIndex].id, orderIndex: orderIndex)
                }
            case .failure(_):
                print("jfhbdsfjknd fsdf")
            }
        }
    }
    
    private func getPositions(orderID: String, orderIndex: Int) {
        DataBaseService.shared.getPositions(orderID: orderID) { result in
            switch result {
            case .success(let positions):
                self.orders[orderIndex].positions = positions
                self.ordersTableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc
    private func reloadButtonPressed() {
        ordersTableView.reloadData()
    }
}

//MARK: Setting View
private extension OrdersViewController {
    func setupView() {
        view.backgroundColor = .white
        
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
        ordersTableView.register(OrderTableViewCell.self, forCellReuseIdentifier: OrderTableViewCell.reuseId)
        
        reloadButton = UIBarButtonItem(title: "Обновить", style: .plain, target: self, action: #selector(reloadButtonPressed))
        navigationItem.rightBarButtonItem = reloadButton
    }
    
    func setupNavigationBar() {
        navigationController?.title = "Список заказоа"
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
    }
}

//MARK: Setting

private extension OrdersViewController {
    func addSubViews() {
        [
            ordersTableView
        ].forEach {
            view.addSubview($0)
        }
    }
}

//MARK: Layout
private extension OrdersViewController {
    func setupLayout() {
        [
            ordersTableView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            ordersTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            ordersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            ordersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            ordersTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

//MARK: Table View DataSource
extension OrdersViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        orders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orders[section].positions.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = ordersTableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.reuseId, for: indexPath) as? OrderTableViewCell else { return UITableViewCell() }
        if indexPath.row < orders[indexPath.section].positions.count {
            cell.configure(
                name: orders[indexPath.section].positions[indexPath.row].product.titile,
                count: String(orders[indexPath.section].positions[indexPath.row].count),
                size: orders[indexPath.section].positions[indexPath.row].size,
                cost: orders[indexPath.section].positions[indexPath.row].cost
            )
        } else {
            cell.configure(name: "Итог:", count: "", size: "", cost: orders[indexPath.section].cost)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Статус: \(orders[section].status)"
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let dateString = dateFormatter.string(from: orders[section].date)

        return "Заказ от: \(dateString)"
    }
}

//MARK:: Table View Delegate
extension OrdersViewController: UITableViewDelegate {
    
}
