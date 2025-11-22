//
//  TrainingViewController.swift
//  Keep
//
//  Created by admin on 13.11.2025.
//

import UIKit

final class TrainingViewController: UIViewController {
    private lazy var contentView =  TrainingView()
    private let viewModel: TrainingViewModelProtocol
    private let coordinator: TrainingCoordinator
    
    init(viewModel: TrainingViewModelProtocol, coordinator: TrainingCoordinator) {
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
        setupTheme()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.setNavigationBarHidden(true, animated: false)
        updateAppearance()
        loadData()
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

private extension TrainingViewController {
    func setupDelegates() {
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        contentView.searchBar.delegate = self
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
        viewModel.loadCollections()
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
    
    func startTraining(collection: CardCollection) {
        let cards = viewModel.getCards(for: collection)
        guard cards.isEmpty == false else {
            showAlert(title: "Пустая коллекция", message: "Добавьте карточки в коллекцию")
            return
        }
        
        coordinator.showCardTraining(with: cards)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableView Delegate & DataSource

extension TrainingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.collectionsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.Identifiers.trainingCell,
            for: indexPath
        ) as? TrainingCollectionCell else { return UITableViewCell() }
        
        if let collection = viewModel.getCollection(at: indexPath.row) {
            cell.configure(with: collection)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let collection = viewModel.getCollection(at: indexPath.row) else { return }
        startTraining(collection: collection)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.Layout.tableRowHeight
    }
}

// MARK: - UISearchBarDelegate

extension TrainingViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterCollections(with: searchText)
        updateUI()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        viewModel.filterCollections(with: "")
        updateUI()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
}
