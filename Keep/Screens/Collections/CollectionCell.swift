//
//  CollectionCell.swift
//  Keep
//
//  Created by admin on 13.11.2025.
//

import UIKit

final class CollectionCell: UICollectionViewCell {
    private var glassView: UIVisualEffectView?
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(font: Typography.collectionName.font)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(font: Typography.cardsCount.font)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        updateGlassAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateGlassAppearance()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGlassAppearance()
    }
    
    func configure(with collection: CardCollection) {
        nameLabel.text = collection.safeName
        countLabel.text = "\(collection.cardsArray.count) карточек"
        updateGlassAppearance()
    }
}

// MARK: - Private Methods

private extension CollectionCell {
    func updateGlassAppearance() {
        glassView?.removeFromSuperview()
        glassView = contentView.applyGlassEffect(cornerRadius: Constants.Layout.cornerRadius)
        updateTextColors()
    }
    
    func updateTextColors() {
        if ThemeManager.shared.currentTheme == .dark {
            nameLabel.textColor = .ypWhite
            countLabel.textColor = .ypLightGray
        } else {
            nameLabel.textColor = .ypDarkGray
            countLabel.textColor = .ypDarkGray
        }
    }
}

// MARK: - Private SetupUI Methods

private extension CollectionCell {
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        layer.cornerRadius = Constants.Layout.cornerRadius
        layer.masksToBounds = false
        layer.shadowColor = UIColor.ypBlack.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 6
        layer.shadowOpacity = 0.15
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(countLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Layout.compactPadding),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Layout.compactPadding),
            
            countLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 14),
            countLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Layout.compactPadding),
            countLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Layout.compactPadding)
        ])
    }
}
