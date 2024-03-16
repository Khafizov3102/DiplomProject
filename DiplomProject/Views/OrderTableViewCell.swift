//
//  OrderTableViewCell.swift
//  DiplomProject
//
//  Created by Денис Хафизов on 19.02.2024.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    
    static let reuseId = "OrderCollectionViewCell"
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .left
        return label
    }()
    private var countLabel = UILabel(text: "")
    private var sizeLabel = UILabel(text: "")
    private var costLabel = UILabel(text: "")
    
    private let stackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubViews()
        setupLayout()
        nameLabel.font = .boldSystemFont(ofSize: 15)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func configure(name: String, count: Int, size: String, cost: Int) {
        nameLabel.text = name
        countLabel.text = "\(count) шт."
        sizeLabel.text = size
        costLabel.text = String(cost)
    }
}

//MARK: Settings View
extension OrderTableViewCell {
    
}

//MARK: Setting
extension OrderTableViewCell {
    func addSubViews() {
        [
            stackView
        ].forEach {
            addSubview($0)
        }
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(countLabel)
        stackView.addArrangedSubview(sizeLabel)
        stackView.addArrangedSubview(costLabel)
        stackView.spacing = 0
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
    }
}

//MARK: Layout
extension OrderTableViewCell {
    func setupLayout() {
        [
            stackView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
            
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
