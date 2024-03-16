//
//  MainTabBarController.swift
//  DiplomProject
//
//  Created by Денис Хафизов on 22.01.2024.
//

import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let catalogVC = CatalogViewController()
        let cardVC = CardViewController()
        let profileVC = ProfileViewController()
        
        viewControllers = [
            generateNavigationController(rootViewController: catalogVC, title: "Каталог", image: UIImage(systemName: "list.bullet") ?? UIImage()),
            generateNavigationController(rootViewController: cardVC, title: "Корзина", image: UIImage(systemName: "cart") ?? UIImage()),
            generateNavigationController(rootViewController: profileVC, title: "Профиль", image: UIImage(systemName: "person") ?? UIImage())
        ]
    }
    
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
}
