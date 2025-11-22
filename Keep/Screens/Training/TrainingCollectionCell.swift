//
//  TrainingCollectionCell.swift
//  Keep
//
//  Created by admin on 13.11.2025.
//

import UIKit

final class TrainingCollectionCell: UITableViewCell {
    private var glassView: UIVisualEffectView?
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.Layout.cornerRadius
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.collectionName.font
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.cardsCount.font
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let arrowImage = UIImageView()
        arrowImage.image = UIImage(systemName: Constants.Images.arrowRight)
        arrowImage.translatesAutoresizingMaskIntoConstraints = false
        return arrowImage
    }()
    
    private lazy var textStack: UIStackView = {
        let textStack = UIStackView(arrangedSubviews: [titleLabel, countLabel])
        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.translatesAutoresizingMaskIntoConstraints = false
        return textStack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        updateGlassAppearance()
        setupSelectionStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGlassAppearance()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateGlassAppearance()
        }
    }
    
    func configure(with collection: CardCollection) {
        titleLabel.text = collection.safeName
        countLabel.text = "\(collection.cardsArray.count) карточек"
        updateColors()
        updateGlassAppearance()
    }
}

// MARK: - Private Methods

private extension TrainingCollectionCell {
    func setupSelectionStyle() {
        selectionStyle = .none
    }
    
    func updateGlassAppearance() {
        glassView?.removeFromSuperview()
        glassView = containerView.applyGlassEffect(cornerRadius: Constants.Layout.cornerRadius)
        updateColors()
        
        containerView.layer.shadowColor = UIColor.ypBlack.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.masksToBounds = false
    }
    
    func updateColors() {
        if ThemeManager.shared.currentTheme == .dark {
            titleLabel.textColor = .ypWhite
            countLabel.textColor = .ypLightGray
            
            if let arrowImageView = containerView.subviews.first(where: { $0 is UIImageView }) as? UIImageView {
                arrowImageView.tintColor = .ypLightGray
            }
        } else {
            titleLabel.textColor = .ypDarkGray
            countLabel.textColor = .ypLightGray
            
            if let arrowImageView = containerView.subviews.first(where: { $0 is UIImageView }) as? UIImageView {
                arrowImageView.tintColor = .ypDarkGray
            }
        }
    }
}

// MARK: - Private SetupUI Methods

private extension TrainingCollectionCell {
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.addSubview(textStack)
        containerView.addSubview(arrowImageView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Layout.defaultPadding),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Layout.defaultPadding),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            textStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.Layout.compactPadding),
            textStack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            textStack.trailingAnchor.constraint(lessThanOrEqualTo: arrowImageView.leadingAnchor, constant: -Constants.Layout.smallPadding),
            
            arrowImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.Layout.defaultPadding),
            arrowImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 12),
            arrowImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
