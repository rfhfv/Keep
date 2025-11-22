//
//  CollectionDetailViewController.swift
//  Keep
//
//  Created by admin on 15.11.2025.
//

import UIKit

final class CollectionDetailViewController: UIViewController {
    private lazy var contentView = CollectionDetailView()
    private let viewModel: CollectionDetailViewModelProtocol
    private let coordinator: CollectionsCoordinator
    
    init(viewModel: CollectionDetailViewModelProtocol, coordinator: CollectionsCoordinator) {
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
        setupDelegates()
        setupActions()
        setupUI()
        setupTheme()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        updateAppearance()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentView.updateAppearance()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Private Methods

private extension CollectionDetailViewController {
    func setupDelegates() {
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        contentView.searchBar.delegate = self
    }
    
    func setupActions() {
        contentView.backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        contentView.addButton.addTarget(self, action: #selector(addCardTapped), for: .touchUpInside)
    }
    
    func setupUI() {
        contentView.setCollectionTitle(viewModel.collection.safeName)
    }
    
    func setupTheme() {
        view.applyThemeBackgroundGradient()
        view.updateGradientOnThemeChange()
        
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("ThemeDidChange"),
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateAppearance()
        }
    }
    
    func loadData() {
        viewModel.loadCards()
        updateUI()
    }
    
    func updateUI() {
        contentView.tableView.reloadData()
        contentView.updateEmptyState(
            isEmpty: viewModel.shouldShowEmptyState,
            isSearching: viewModel.isSearching
        )
    }
    
    func updateAppearance() {
        contentView.updateAppearance()
    }
    
    @objc func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func addCardTapped() {
        showLanguageSelectionAlert()
    }
    
    func showLanguageSelectionAlert() {
        let alert = UIAlertController(
            title: "Выберите язык",
            message: "На каком языке будет слово?",
            preferredStyle: .actionSheet
        )
        
        let languages = [
            ("Английский", "en"),
            ("Русский", "ru"),
            ("Немецкий", "de")
        ]
        
        for (title, code) in languages {
            let action = UIAlertAction(title: title, style: .default) { [weak self] _ in
                self?.showManualCardAlert(language: code)
            }
            alert.addAction(action)
        }
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = contentView.addButton
            popoverController.sourceRect = contentView.addButton.bounds
        }
        
        present(alert, animated: true)
    }
    
    func showManualCardAlert(language: String) {
        let alert = UIAlertController(
            title: "Новая карточка (\(language.uppercased()))",
            message: "Введите слово и перевод",
            preferredStyle: .alert
        )
        
        alert.addTextField { textField in
            textField.placeholder = "Слово на \(self.getLanguageName(code: language))"
            textField.autocapitalizationType = .sentences
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Перевод на русский"
            textField.autocapitalizationType = .sentences
        }
        
        let addAction = UIAlertAction(title: "Добавить", style: .default) { [weak self] _ in
            guard let self = self,
                  let frontText = alert.textFields?[0].text, frontText.trimmingCharacters(in: .whitespaces).isEmpty == false,
                  let backText = alert.textFields?[1].text, backText.trimmingCharacters(in: .whitespaces).isEmpty == false else {
                self?.showErrorAlert(message: "Пожалуйста, заполните все поля")
                return
            }
            
            _ = self.viewModel.addManualCard(
                frontText: frontText,
                backText: backText,
                source: language,
                target: "ru"
            )
            
            self.updateUI()
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func getLanguageName(code: String) -> String {
        let languageNames = [
            "en": "английском", "ru": "русском", "de": "немецком"
        ]
        return languageNames[code] ?? code
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableView Delegate & DataSource

extension CollectionDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cardsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.Identifiers.cardCell,
            for: indexPath
        ) as? CardDetailCell else { return UITableViewCell() }
        
        if let card = viewModel.getCard(at: indexPath.row) {
            cell.configure(with: card)
            
            cell.onPlayTapped = { [weak self] in
                cell.setLoading(true)
                self?.viewModel.speakText(card.safeFrontText, language: card.safeSourceLanguage)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + Constants.Animation.audioTimeout) {
                    cell.setLoading(false)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let card = viewModel.getCard(at: indexPath.row) else { return }
            viewModel.deleteCard(card)
            updateUI()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UISearchBarDelegate

extension CollectionDetailViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterCards(with: searchText)
        updateUI()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        viewModel.filterCards(with: "")
        updateUI()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
}
