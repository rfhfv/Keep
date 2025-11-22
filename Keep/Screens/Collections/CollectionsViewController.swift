//
//  ViewController.swift
//  Keep
//
//  Created by admin on 12.11.2025.
//

import UIKit

final class CollectionsViewController: UIViewController {
    private let viewModel: CollectionsViewModelProtocol
    private let coordinator: CollectionsCoordinatorProtocol
    private lazy var collectionsView = CollectionsView()
    
    init(viewModel: CollectionsViewModelProtocol, coordinator: CollectionsCoordinatorProtocol) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = collectionsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        setupActions()
        setupTheme()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        updateAppearance()
        loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionsView.updateAppearance()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Private Methods

private extension CollectionsViewController {
    func setupDelegates() {
        collectionsView.collectionView.delegate = self
        collectionsView.collectionView.dataSource = self
        collectionsView.searchBar.delegate = self
    }
    
    func setupActions() {
        collectionsView.addButton.addTarget(self, action: #selector(addCollectionTapped), for: .touchUpInside)
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
        collectionsView.collectionView.reloadData()
        collectionsView.updateEmptyState(
            isEmpty: viewModel.shouldShowEmptyState,
            isSearching: viewModel.isSearching
        )
    }
    
    func updateAppearance() {
        collectionsView.updateAppearance()
    }
    
    @objc func addCollectionTapped() {
        let alert = UIAlertController(title: "Новая коллекция", message: "Введите название", preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Название коллекции" }
        
        alert.addAction(UIAlertAction(title: "Создать", style: .default) { [weak self] _ in
            guard let name = alert.textFields?.first?.text, name.isEmpty == false else { return }
            if let collection = self?.viewModel.createCollection(name: name) {
                self?.coordinator.showCollectionDetail(collection)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - UICollectionView DataSource & Delegate

extension CollectionsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.collectionsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? CollectionCell else { return UICollectionViewCell() }
        
        if let collection = viewModel.getCollection(at: indexPath.item) {
            cell.configure(with: collection)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let collection = viewModel.getCollection(at: indexPath.item) else { return }
        
        let alert = UIAlertController(title: collection.safeName, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Открыть", style: .default) { [weak self] _ in
            self?.coordinator.showCollectionDetail(collection)
        })
        
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            self?.viewModel.deleteCollection(collection)
            self?.updateUI()
        })
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        if let popoverController = alert.popoverPresentationController,
           let cell = collectionView.cellForItem(at: indexPath) {
            popoverController.sourceView = cell
            popoverController.sourceRect = cell.bounds
        }
        
        present(alert, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension CollectionsViewController: UISearchBarDelegate {
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
