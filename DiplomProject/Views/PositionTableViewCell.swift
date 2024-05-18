//
//  PositionTableViewCell.swift
//  DiplomProject
//
//  Created by Денис Хафизов on 09.02.2024.
//

import UIKit

class PositionTableViewCell: UITableViewCell {
    
    static let reuseId = "PositionCollectionViewCell"
    
    private var nameLabel = UILabel(text: "", labelFont: .boldSystemFont(ofSize: 15), textAlignment: .center)
    private var countLabel = UILabel(text: "", textAlignment: .center)
    private var sizeLabel = UILabel(text: "", textAlignment: .center)
    private var costLabel = UILabel(text: "", textAlignment: .center)
    
    private let stackView = UIStackView()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func configure(name: String, count: Int, size: String, cost: Int) {
        nameLabel.text = name
        countLabel.text = String(count)
        sizeLabel.text = size
        costLabel.text = String(cost)
    }
}

//MARK: Settings View
extension PositionTableViewCell {
    
}

//MARK: Setting
extension PositionTableViewCell {
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
extension PositionTableViewCell {
    func setupLayout() {
        [
            stackView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([            
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
}
