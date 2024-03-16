//
//  AdminViewController.swift
//  DiplomProject
//
//  Created by Денис Хафизов on 20.02.2024.
//

import UIKit

final class AdminViewController: UIViewController {
    
    private var orders = [Order]()
    private var positions = [Position]()
    
    private let ordersTableView = UITableView()
    
    private var reloadButton = UIBarButtonItem()
    private var signOutButton = UIBarButtonItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        addSubViews()
        setupLayout()
        getOrders()
    }
    
    private func getOrders() {
        DataBaseService.shared.getOrders(userID: nil) { result in
            switch result {
            case .success(let orders):
                self.orders = orders
                
                for orderIndex in 0..<orders.count {
                    self.getPositions(orderID: orders[orderIndex].id, orderIndex: orderIndex)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func getPositions(orderID: String, orderIndex: Int) {
        DataBaseService.shared.getPositions(orderID: orderID) { result in
            switch result {
            case .success(let positions):
                self.orders[orderIndex].positions = positions
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc
    private func reloadButtonPressed() {
        ordersTableView.reloadData()
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
        orders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ordersTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Итог: \(orders[indexPath.section].cost)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let dateString = dateFormatter.string(from: orders[section].date)

        return "Заказ от: \(dateString)"
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        "Итог: \(orders[section].cost)"
    }
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
