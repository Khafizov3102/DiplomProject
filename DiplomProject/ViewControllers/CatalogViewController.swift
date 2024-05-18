//
//  CatalogTableViewController.swift
//  DiplomProject
//
//  Created by Денис Хафизов on 02.02.2024.
//

import UIKit

final class CatalogViewController: UIViewController {
    
    let tableView = UITableView()
    
    var cells: [Product] = Product.fetchData()
    var favoriteCells: [Product] = Product.fetchData().filter { $0.isRecommend }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CatalogTableViewCell.self, forCellReuseIdentifier: CatalogTableViewCell.reuseId)
        tableView.delegate = self
        tableView.dataSource = self
        
        setupView()
        addSubViews()
        setupLayout()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        
        let searchController = UISearchController()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Каталог"
        
        tableView.rowHeight = 150
    }
    
}

// MARK: Settings View
private extension CatalogViewController {
    func setupView() {
        view.backgroundColor = .mainDark()
        
    }
}

// MARK: Setting
private extension CatalogViewController {
    func addSubViews() {
        [
            tableView
        ].forEach {
            view.addSubview($0)
        }
    }
}

// MARK: Layout
private extension CatalogViewController {
    func setupLayout() {
        [
            tableView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - TableViewDataSource
extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let titleLabel = UILabel()
        titleLabel.font = .boldSystemFont(ofSize: 20)
        
        switch section {
        case 0:
            titleLabel.text = "Популярное"
        case 1:
            titleLabel.text = "Пиццы"
        default:
            titleLabel.text = "gdfgfd"
        }
        titleLabel.translatesAutoresizingMaskIntoConstraints = false 
        headerView.addSubview(titleLabel)
        
        return headerView
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return favoriteCells.count
        } else {
            return cells.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CatalogTableViewCell.reuseId, for: indexPath) as?
                CatalogTableViewCell else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            cell.configure(
                ImageView: favoriteCells[indexPath.row].imageUrl,
                productName: favoriteCells[indexPath.row].titile,
                productDiscription: favoriteCells[indexPath.row].description,
                productPrice: favoriteCells[indexPath.row].price
            )
        } else {
            cell.configure(
                ImageView: cells[indexPath.row].imageUrl,
                productName: cells[indexPath.row].titile,
                productDiscription: cells[indexPath.row].description,
                productPrice: cells[indexPath.row].price
            )
        }
        
        return cell
    }
}

// MARK: - TableViewDelegate
extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productVC = ProductViewController()
        productVC.configure(product: cells[indexPath.row])
        present(productVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension CatalogViewController: UISearchBarDelegate {
    
}
