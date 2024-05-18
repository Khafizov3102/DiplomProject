//
//  ViewController.swift
//  DiplomProject
//
//  Created by Денис Хафизов on 13.01.2024.
//

import UIKit

final class AuthViewController: UIViewController {
    
    private let authLabel = UILabel(text: "Авторизация", labelFont: .mainFont26())
    private let emailLabel = UILabel(text: "Email:")
    private let passwordLabel = UILabel(text: "Пароль:")
    private let regAccountLabel = UILabel(text: "Еще не зарегистрированны?")
    
    private let emailTF = CustomTextFieldForm(keyboardType: .default)
    private let passwordTF = CustomTextFieldForm(keyboardType: .default, isPassword: true)
    
    private var emailStackView = UIStackView()
    private var passwordStackView = UIStackView()
    private var mainStackView = UIStackView()
    private let signUpStackView = UIStackView()
    
    private let authButton = UIButton(title: "Войти", titleColor: .white, backgroundColor: .darkGray)
    private let signUpButton = UIButton(title: "Регистрация", titleColor: .mainRed(), backgroundColor: .white)
    
    private let mainTabBar = MainTabBarController()
    private let registrationVC = RegistrationViewController()
    private let adminVC = AdminViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubViews()
        setupLayout()
        isUserLogin()
        
        authButton.addTarget(self, action: #selector(authButtonPressed), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
    }
    
    private func isUserLogin() {
        AuthService.shared.isUserLogin { [unowned self] result in
            switch result {
            case .success(_):
                if AuthService.shared.currentUser?.uid == "hNFwj4VivJNv9qPCRR1BxdH4Loz1" {
                    let navigationVC = UINavigationController(rootViewController: adminVC)
                    navigationVC.modalPresentationStyle = .fullScreen
                    present(navigationVC, animated: true)
                } else {
                    mainTabBar.modalPresentationStyle = .fullScreen
                    present(mainTabBar, animated: true)
                }
            case .failure(let error):
                showAlert(title: "Login error", message: error.localizedDescription)
            }
        }
    }
    
    @objc
    private func authButtonPressed() {
        guard let email = emailTF.text, let password = passwordTF.text  else { return }
        AuthService.shared.signIn(email: email, password: password) { [unowned self] result in
            switch result {
            case .success(_):
                print("")
            case .failure(let error):
                showAlert(title: "Login error", message: error.localizedDescription)
            }
        }
    }
    
    @objc
    private func signUpButtonPressed() {
        registrationVC.modalPresentationStyle = .fullScreen
        present(registrationVC, animated: true)
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
}

// MARK: Settings View
private extension AuthViewController {
    func setupView() {
        view.backgroundColor = .white
    }
}

// MARK: Setting
private extension AuthViewController {
    func addSubViews() {
        [
            authLabel,
            signUpStackView,
            mainStackView
        ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        emailStackView = UIStackView(arrangedSubviews: [emailLabel, emailTF], axis: .vertical, spacing: 0, distribution: .fill)
        passwordStackView = UIStackView(arrangedSubviews: [passwordLabel, passwordTF], axis: .vertical, spacing: 0, distribution: .fill)
        
        mainStackView.addArrangedSubview(emailStackView)
        mainStackView.addArrangedSubview(passwordStackView)
        mainStackView.addArrangedSubview(authButton)
        mainStackView.spacing = 40
        mainStackView.axis = .vertical
        mainStackView.distribution = .fill
        
        signUpStackView.addArrangedSubview(regAccountLabel)
        signUpStackView.addArrangedSubview(signUpButton)
        signUpStackView.spacing = 0
        signUpStackView.axis = .vertical
        signUpStackView.distribution = .fill
    }
}

// MARK: Layout
private extension AuthViewController {
    func setupLayout() {
        NSLayoutConstraint.activate([
            authLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            authLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: authLabel.bottomAnchor, constant: 120),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            signUpStackView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 80),
            signUpStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
