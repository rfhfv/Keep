//
//  CardDetailCell.swift
//  Keep
//
//  Created by admin on 15.11.2025.
//

import UIKit

final class CardDetailCell: UITableViewCell {
    private var glassView: UIVisualEffectView?
    var onPlayTapped: (() -> Void)?
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.Layout.cornerRadius
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let frontLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(font: Typography.frontLabel.font, alignment: .left)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let backLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(font: Typography.backLabel.font, alignment: .left)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: Constants.Images.speaker), for: .normal)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let languageBadge: UILabel = {
        let label = UILabel()
        label.configureLabel(font: Typography.languageBadge.font, textColor: .ypWhite)
        label.backgroundColor = .ypBlue
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.isHidden = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var textStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [frontLabel, backLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [loadingIndicator, playButton])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [textStack, buttonStack])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
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
    
    func configure(with card: Card) {
        frontLabel.text = card.safeFrontText
        backLabel.text = card.safeBackText
        
        updateTextColors()
        updateGlassAppearance()
        
        languageBadge.text = card.safeSourceLanguage.uppercased()
        languageBadge.isHidden = false
    }
    
    func setLoading(_ isLoading: Bool) {
        if isLoading {
            loadingIndicator.startAnimating()
            playButton.isHidden = true
        } else {
            loadingIndicator.stopAnimating()
            playButton.isHidden = false
        }
    }
}

// MARK: - Private Methods

private extension CardDetailCell {
    @objc func playTapped() {
        setLoading(true)
        onPlayTapped?()
    }
    
    func updateGlassAppearance() {
        glassView?.removeFromSuperview()
        glassView = containerView.applyGlassEffect(cornerRadius: Constants.Layout.cornerRadius)
        
        updateTextColors()
        updatePlayButtonColor()
        
        containerView.layer.shadowColor = UIColor.ypBlack.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.masksToBounds = false
    }
    
    func setupSelectionStyle() {
        selectionStyle = .none
    }
    
    func updateTextColors() {
        if ThemeManager.shared.currentTheme == .dark {
            frontLabel.textColor = .ypWhite
            backLabel.textColor = .ypLightGray
        } else {
            frontLabel.textColor = .ypDarkGray
            backLabel.textColor = .ypLightGray
        }
    }
    
    func updatePlayButtonColor() {
        if ThemeManager.shared.currentTheme == .dark {
            playButton.tintColor = .ypWhite
        } else {
            playButton.tintColor = .ypDarkGray
        }
    }
}

// MARK: - Private SetupUI Methods

private extension CardDetailCell {
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        
        contentView.addSubview(containerView)
        containerView.addSubview(mainStack)
        containerView.addSubview(languageBadge)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Layout.defaultPadding),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Layout.defaultPadding),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            mainStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.Layout.defaultPadding),
            mainStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.Layout.defaultPadding),
            mainStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.Layout.defaultPadding),
            mainStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constants.Layout.defaultPadding),
            
            playButton.widthAnchor.constraint(equalToConstant: 30),
            playButton.heightAnchor.constraint(equalToConstant: 30),
            
            loadingIndicator.widthAnchor.constraint(equalToConstant: 20),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 20),
            
            languageBadge.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.Layout.compactPadding),
            languageBadge.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.Layout.compactPadding),
            languageBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.Layout.languageBadgeWidth),
            languageBadge.heightAnchor.constraint(equalToConstant: Constants.Layout.languageBadgeHeight)
        ])
        updateGlassAppearance()
    }
}
