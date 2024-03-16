//
//  CatalogTableViewCell.swift
//  DiplomProject
//
//  Created by Денис Хафизов on 02.02.2024.
//

import UIKit

final class CatalogTableViewCell: UITableViewCell {
    
    static let reuseId = "CatalogCollectionViewCell"
    
    let productImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.backgroundColor = .systemCyan
        imageView.image = UIImage(named: "pizza")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let productNameLabel: UILabel = {
       let label = UILabel()
        label.text = "Название"
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    let productDiscriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "JHBjnd.kffsdfmdslf d.mkfnlkg fk gdfkgnfgkjlndm glvgokfm dkgm dfm,v d.kmfngkdjv kdfn.vm, c,vx c.kgjdbfjldnvkmc ,v.xvbvfb"
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    let productPriceLabel = UILabel(text: "900Р")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        addSubViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(ImageView: String,
                   productName: String,
                   productDiscription: String,
                   productPrice: Int) {
        productImageView.image = UIImage(named: ImageView)
        productNameLabel.text = productName
        productDiscriptionLabel.text = productDiscription
        productPriceLabel.text = String(productPrice)
    }
}

// MARK: Settings View
private extension CatalogTableViewCell {
    func setupView() {
        
    }
}

// MARK: Setting
private extension CatalogTableViewCell {
    func addSubViews() {
        [
            productImageView,
            productNameLabel,
            productDiscriptionLabel,
            productPriceLabel
        ].forEach {
            addSubview($0)
        }
    }
}

// MARK: Layout
private extension CatalogTableViewCell {
    func setupLayout() {
        [
            productImageView,
            productNameLabel,
            productDiscriptionLabel,
            productPriceLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: topAnchor),
            productImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            productImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 150),
            
            productNameLabel.topAnchor.constraint(equalTo: topAnchor),
            productNameLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 10),
            productNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            productDiscriptionLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 5),
            productDiscriptionLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 10),
            productDiscriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            productPriceLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            productPriceLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 10)
        ])
    }
}
