//
//  CardTrainingView.swift
//  Keep
//
//  Created by admin on 18.11.2025.
//

import UIKit

protocol CardTrainingViewProtocol: ThemeableView {
    var nextButton: UIButton { get }
    var backButton: UIButton { get }
    var cardView: UIView { get }
    var cardLabel: UILabel { get }
    var playButton: UIButton { get }
    var flipButton: UIButton { get }
    
    func updateCard(text: String, language: String, progress: String, isShowingFront: Bool)
}

final class CardTrainingView: UIView, CardTrainingViewProtocol {
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: Constants.Images.back), for: .normal)
        button.layer.cornerRadius = Constants.Layout.cornerRadiusSmall
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.Layout.cornerRadiusLarge
        view.layer.shadowColor = UIColor.ypBlack.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 12
        view.layer.shadowOpacity = 0.15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cardLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(font: Typography.cardLabel.font)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let languageLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(font: Typography.cardLanguageLabel.font)
        label.backgroundColor = .clear
        label.layer.cornerRadius = Constants.Layout.cornerRadiusSmall
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: Constants.Images.speakerFill), for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = Constants.Layout.cornerRadiusLarge
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let flipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.Strings.flipCard, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = Constants.Layout.cornerRadiusSmall
        button.layer.shadowColor = UIColor.ypBlack.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.Strings.nextCard, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = Constants.Layout.cornerRadiusSmall
        button.layer.shadowColor = UIColor.ypBlack.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(font: Typography.progressLabel.font)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateAppearance() {
        applyThemeBackgroundGradient()
        updateCardAppearance()
        updateButtonsAppearance()
        updateTextColors()
    }
    
    func updateColors() {
        if ThemeManager.shared.currentTheme == .dark {
            backButton.tintColor = .ypWhite
            cardLabel.textColor = .ypWhite
            progressLabel.textColor = .ypWhite
            languageLabel.textColor = .ypWhite
            flipButton.setTitleColor(.white, for: .normal)
            nextButton.setTitleColor(.white, for: .normal)
            playButton.tintColor = .ypWhite
        } else {
            backButton.tintColor = .ypDarkGray
            cardLabel.textColor = .ypDarkGray
            progressLabel.textColor = .ypDarkGray
            languageLabel.textColor = .ypDarkGray
            flipButton.setTitleColor(.ypDarkGray, for: .normal)
            nextButton.setTitleColor(.ypDarkGray, for: .normal)
            playButton.tintColor = .ypDarkGray
        }
    }
    
    func updateCard(text: String, language: String, progress: String, isShowingFront: Bool) {
        cardLabel.text = text
        languageLabel.text = language.uppercased()
        progressLabel.text = progress
        playButton.isHidden = !isShowingFront
    }
}

// MARK: - Private Methods

private extension CardTrainingView {
    func updateCardAppearance() {
        cardView.applyGlassEffect(cornerRadius: Constants.Layout.cornerRadiusLarge)
    }
    
    func updateButtonsAppearance() {
        if ThemeManager.shared.currentTheme == .dark {
            flipButton.backgroundColor = UIColor(white: 0.3, alpha: 0.5)
            nextButton.backgroundColor = UIColor(white: 0.3, alpha: 0.5)
        } else {
            flipButton.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
            nextButton.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        }
    }
    
    func updateTextColors() {
        updateColors()
    }
}

// MARK: - Private SetupUI Methods

private extension CardTrainingView {
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        backgroundColor = .clear
        
        cardView.addSubview(languageLabel)
        cardView.addSubview(cardLabel)
        cardView.addSubview(playButton)
        addSubview(cardView)
        addSubview(flipButton)
        addSubview(nextButton)
        addSubview(progressLabel)
        addSubview(backButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.Layout.defaultPadding),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Layout.defaultPadding),
            backButton.widthAnchor.constraint(equalToConstant: Constants.Layout.buttonSize),
            backButton.heightAnchor.constraint(equalToConstant: Constants.Layout.buttonSize),
            
            cardView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 18),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Layout.defaultPadding),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Layout.defaultPadding),
            cardView.heightAnchor.constraint(equalToConstant: Constants.Layout.cardViewHeight),
            
            languageLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: Constants.Layout.defaultPadding),
            languageLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: Constants.Layout.defaultPadding),
            languageLabel.widthAnchor.constraint(equalToConstant: 60),
            languageLabel.heightAnchor.constraint(equalToConstant: 40),
            
            cardLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            cardLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: Constants.Layout.largePadding),
            cardLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -Constants.Layout.largePadding),
            
            playButton.topAnchor.constraint(equalTo: cardView.topAnchor, constant: Constants.Layout.defaultPadding),
            playButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -Constants.Layout.defaultPadding),
            playButton.widthAnchor.constraint(equalToConstant: 60),
            playButton.heightAnchor.constraint(equalToConstant: 40),
            
            flipButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: Constants.Layout.extraLargePadding),
            flipButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Layout.defaultPadding),
            flipButton.trailingAnchor.constraint(equalTo: nextButton.leadingAnchor, constant: -Constants.Layout.compactPadding),
            flipButton.heightAnchor.constraint(equalToConstant: 70),
            flipButton.widthAnchor.constraint(equalTo: nextButton.widthAnchor),
            
            nextButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: Constants.Layout.extraLargePadding),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Layout.defaultPadding),
            nextButton.heightAnchor.constraint(equalToConstant: 70),
            
            progressLabel.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 20),
            progressLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Layout.defaultPadding),
            progressLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Layout.defaultPadding)
        ])
    }
}
