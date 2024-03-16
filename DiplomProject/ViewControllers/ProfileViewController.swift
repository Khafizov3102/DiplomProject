//
//  ProfileViewController.swift
//  DiplomProject
//
//  Created by Денис Хафизов on 21.01.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private var profile = Profile(id: "", name: "", phone: 0, address: "")
    
    private let logOutButton = UIButton(title: "Выйти", titleColor: .white, backgroundColor: .mainRed())
    private let saveButton = UIButton(title: "Сохранить", titleColor: .white, backgroundColor: .systemGreen)
    private let ordersButton = UIButton(title: "Список заказов", titleColor: .white, backgroundColor: .mainDark())
    
    private let userNameLabel = UILabel(text: "Имя:")
    private let userPhoneLabel = UILabel(text: "Телефон:")
    private let userAddressLabel = UILabel(text: "Адрес: ")
    private let welcomeLabel = UILabel(text: "")
    
    private let userNameTF = AuthTextFieldForm(isActive: true)
    private let userPhoneTF = AuthTextFieldForm(isActive: true)
    private let userAddressTF = AuthTextFieldForm(isActive: true)

    private var mainStackView = UIStackView()
    private var LabelsStackView = UIStackView()
    private var TextFieldsStackView = UIStackView()
    private var buttonsStackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubViews()
        setupLayout()
        getProfile()
                
        userNameTF.delegate = self
        userPhoneTF.delegate = self
        userAddressTF.delegate = self
    }
    
    private func getProfile() {
        DataBaseService.shared.getProfile { [unowned self] result in
            switch result {
            case .success(let user):
                profile.id = user.id
                profile.name = user.name
                profile.phone = user.phone
                profile.address = user.address
                
                updateProfileInfo()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc
    private func saveButtonPressed() {
        profile.name = userNameTF.text ?? ""
        profile.phone = Int(userPhoneTF.text ?? "") ?? 0
        profile.address = userAddressTF.text ?? ""
        setProfile()
    }
    
    @objc
    private func ordersButtonPressed() {
        let ordersVC = OrdersViewController()
        navigationController?.pushViewController(ordersVC, animated: true)
    }
    
    private func setProfile() {
        DataBaseService.shared.createProfile(user: profile) { result in
            switch result {
            case .success(_):
                print("setUser +")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func updateProfileInfo() {
        userNameTF.text = profile.name
        userPhoneTF.text = String(profile.phone)
        userAddressTF.text = profile.address
    }
    
    @objc
    private func regButtonPressed() {
        AuthService.shared.signOut()
        dismiss(animated: true)
    }
}

// MARK: Settings View
private extension ProfileViewController {
    func setupView() {
        view.backgroundColor = .white
        
        title = "Профиль"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false

        logOutButton.addTarget(self, action: #selector(regButtonPressed), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        saveButton.isEnabled = false
        ordersButton.addTarget(self, action: #selector(ordersButtonPressed), for: .touchUpInside)
    }
}

// MARK: Setting
private extension ProfileViewController {
    func addSubViews() {
        [
            mainStackView,
            ordersButton,
            buttonsStackView
        ].forEach {
            view.addSubview($0)
        }
        
        LabelsStackView.addArrangedSubview(userNameLabel)
        LabelsStackView.addArrangedSubview(userPhoneLabel)
        LabelsStackView.addArrangedSubview(userAddressLabel)
        LabelsStackView.spacing = 40
        LabelsStackView.axis = .vertical
        
        TextFieldsStackView.addArrangedSubview(userNameTF)
        TextFieldsStackView.addArrangedSubview(userPhoneTF)
        TextFieldsStackView.addArrangedSubview(userAddressTF)
        TextFieldsStackView.spacing = 40
        TextFieldsStackView.axis = .vertical
        
        mainStackView.addArrangedSubview(LabelsStackView)
        mainStackView.addArrangedSubview(TextFieldsStackView)
        mainStackView.spacing = 5
        mainStackView.axis = .horizontal
        mainStackView.distribution = .fill
        
        buttonsStackView.addArrangedSubview(saveButton)
        buttonsStackView.addArrangedSubview(logOutButton)
        buttonsStackView.spacing = 20
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fillEqually
    }
}

// MARK: Layout
private extension ProfileViewController {
    func setupLayout() {
        [
            userNameLabel,
            userPhoneLabel,
            userAddressLabel,
            userNameTF,
            userPhoneTF,
            userAddressTF,
            saveButton,
            logOutButton,
            ordersButton,
            LabelsStackView,
            TextFieldsStackView,
            buttonsStackView,
            mainStackView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            buttonsStackView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 80),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),

            ordersButton.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 20),
            ordersButton.leadingAnchor.constraint(equalTo: buttonsStackView.leadingAnchor),
            ordersButton.trailingAnchor.constraint(equalTo: buttonsStackView.trailingAnchor)
        ])
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = true
    }
}
