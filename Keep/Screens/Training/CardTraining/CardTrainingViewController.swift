//
//  CardTrainingViewController.swift
//  Keep
//
//  Created by admin on 18.11.2025.
//

import UIKit

final class CardTrainingViewController: UIViewController {
    private lazy var contentView = CardTrainingView()
    private let viewModel: CardTrainingViewModelProtocol
    private let coordinator: TrainingCoordinator
    
    init(viewModel: CardTrainingViewModelProtocol, coordinator: TrainingCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        setupTheme()
        updateCard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentView.updateAppearance()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            setupTheme()
            contentView.updateAppearance()
        }
    }
}

// MARK: - Private Methods

private extension CardTrainingViewController {
    func setupActions() {
        contentView.backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        contentView.flipButton.addTarget(self, action: #selector(flipCard), for: .touchUpInside)
        contentView.nextButton.addTarget(self, action: #selector(nextCard), for: .touchUpInside)
        contentView.playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(flipCard))
        contentView.cardView.addGestureRecognizer(tapGesture)
        contentView.cardView.isUserInteractionEnabled = true
    }
    
    func setupTheme() {
        view.applyThemeBackgroundGradient()
        view.updateGradientOnThemeChange()
    }
    
    @objc func flipCard() {
        viewModel.flipCard()
        UIView.transition(
            with: contentView.cardView,
            duration: Constants.Animation.flipDuration,
            options: .transitionFlipFromRight,
            animations: {
                self.updateCard()
            }
        )
    }
    
    @objc func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextCard() {
        viewModel.nextCard()
        updateCard()
    }
    
    @objc func playTapped() {
        UIView.animate(withDuration: Constants.Animation.buttonPressDuration, animations: {
            self.contentView.playButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: Constants.Animation.buttonPressDuration) {
                self.contentView.playButton.transform = CGAffineTransform.identity
            }
        }
        
        viewModel.speakCurrentText()
    }
    
    func updateCard() {
        guard viewModel.hasCards else { return }
        
        contentView.updateCard(
            text: viewModel.currentText,
            language: viewModel.currentLanguage,
            progress: viewModel.progressText,
            isShowingFront: viewModel.isShowingFront
        )
    }
}
