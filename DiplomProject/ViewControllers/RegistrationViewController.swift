//
//  RegistrationViewController.swift
//  DiplomProject
//
//  Created by Денис Хафизов on 21.01.2024.
//

import UIKit

final class RegistrationViewController: UIViewController {
    
    private let regLabel = UILabel(text: "Регистрация", labelFont: .mainFont26())
    private let emailLabel = UILabel(text: "Email:")
    private let passwordLabel = UILabel(text: "Пароль:")
    private let confirmPasswordLabel = UILabel(text: "Повторите пароль:")
    private let authAccountLabel = UILabel(text: "Уже есть аккаунт?")
    
    private let emailTF = CustomTextFieldForm(keyboardType: .default)
    private let confirmPasswordTF = CustomTextFieldForm(keyboardType: .default, isPassword: true)
    private let passwordTF = CustomTextFieldForm(keyboardType: .default, isPassword: true)
    
    private let emailStackView = UIStackView()
    private let passwordStackView = UIStackView()
    private let confirmPasswordStackView = UIStackView()
    private let mainStackView = UIStackView()
    private let signInStackView = UIStackView()
    
    private let regButton = UIButton(title: "Зарегистрироваться", titleColor: .white, backgroundColor: .darkGray)
    private let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.mainRed(), for: .normal)
        button.titleLabel?.font = .mainFont20()
        return button
    }()
    
    private let mainTabBar = MainTabBarController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        addSubViews()
        setupLayout()
        isUserLogin()
        
        regButton.addTarget(self, action: #selector(regButtonPressed), for: .touchUpInside)
        signInButton.addTarget(self, action: #selector(signInButtonPressed), for: .touchUpInside)
    }
    
    private func isUserLogin() {
        AuthService.shared.isUserLogin { [unowned self] result in
            switch result {
            case .success(_):
                mainTabBar.modalPresentationStyle = .fullScreen
                present(mainTabBar, animated: true)
            case .failure(let error):
                showAlert(title: "Registration error", message: error.localizedDescription)
            }
        }
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
    private func regButtonPressed() {
        guard let email = emailTF.text, let password = passwordTF.text, let confirmPassword = confirmPasswordTF.text else { return }
        guard password == confirmPassword else { return }
        AuthService.shared.signUp(email: email, password: password) { result in
            switch result {
            case .success(_):
                print("reg +")
            case .failure(let error):
                print("Ошибка: \(error.localizedDescription)")
            }
        }
    }
    
    @objc
    private func signInButtonPressed() {
        dismiss(animated: true)
    }
}

// MARK: Settings View
private extension RegistrationViewController {
    func setupView() {
        view.backgroundColor = .white
    }
}

// MARK: Setting
private extension RegistrationViewController {
    func addSubViews() {
        [
            regLabel,
            signInStackView,
            mainStackView
        ].forEach {
            view.addSubview($0)
        }
        
        emailStackView.addArrangedSubview(emailLabel)
        emailStackView.addArrangedSubview(emailTF)
        emailStackView.spacing = 0
        emailStackView.axis = .vertical
        emailStackView.distribution = .fill
        
        passwordStackView.addArrangedSubview(passwordLabel)
        passwordStackView.addArrangedSubview(passwordTF)
        passwordStackView.spacing = 0
        passwordStackView.axis = .vertical
        passwordStackView.distribution = .fill
        
        confirmPasswordStackView.addArrangedSubview(confirmPasswordLabel)
        confirmPasswordStackView.addArrangedSubview(confirmPasswordTF)
        confirmPasswordStackView.spacing = 0
        confirmPasswordStackView.axis = .vertical
        confirmPasswordStackView.distribution = .fill
        
        mainStackView.addArrangedSubview(emailStackView)
        mainStackView.addArrangedSubview(passwordStackView)
        mainStackView.addArrangedSubview(confirmPasswordStackView)
        mainStackView.addArrangedSubview(regButton)
        mainStackView.spacing = 40
        mainStackView.axis = .vertical
        mainStackView.distribution = .fill
        
        signInStackView.addArrangedSubview(authAccountLabel)
        signInStackView.addArrangedSubview(signInButton)
        signInStackView.spacing = 0
        signInStackView.axis = .vertical
        signInStackView.distribution = .fill
    }
}

// MARK: Layout
private extension RegistrationViewController {
    func setupLayout() {
        [
            regLabel,
            emailLabel,
            passwordLabel,
            confirmPasswordLabel,
            authAccountLabel,
            regButton,
            signInButton,
            emailTF,
            passwordTF,
            confirmPasswordTF,
            emailStackView,
            passwordStackView,
            confirmPasswordStackView,
            signInStackView,
            mainStackView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            regLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            regLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: regLabel.bottomAnchor, constant: 120),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            signInStackView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 80),
            signInStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
