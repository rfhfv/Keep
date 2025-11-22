//
//  CollectionDetailView.swift
//  Keep
//
//  Created by admin on 15.11.2025.
//

import UIKit

protocol CollectionDetailViewProtocol: ThemeableView, EmptyStateView {
    var tableView: UITableView { get }
    var searchBar: UISearchBar { get }
    var backButton: UIButton { get }
    var addButton: UIButton { get }
    
    func updateEmptyState(isEmpty: Bool, isSearching: Bool)
    func setCollectionTitle(_ title: String)
}

final class CollectionDetailView: UIView, CollectionDetailViewProtocol {
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .ypWhite
        button.setImage(UIImage(systemName: Constants.Images.back), for: .normal)
        button.layer.cornerRadius = Constants.Layout.cornerRadiusSmall
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(font: Typography.titleDetail.font, alignment: .left, textColor: .ypWhite)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .ypWhite
        button.setImage(UIImage(systemName: Constants.Images.plus), for: .normal)
        button.layer.cornerRadius = Constants.Layout.cornerRadiusSmall
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let searchContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.Layout.cornerRadiusSmall
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = Constants.Strings.searchPlaceholder
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundImage = UIImage()
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.searchTextField.borderStyle = .none
        return searchBar
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(CardDetailCell.self, forCellReuseIdentifier: Constants.Identifiers.cardCell)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.contentInset = UIEdgeInsets(
            top: Constants.Layout.smallPadding,
            left: 0,
            bottom: Constants.Layout.extraLargePadding,
            right: 0
        )
        return table
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(font: Typography.emptyState.font, textColor: .ypWhite)
        label.isHidden = true
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
        updateSearchContainerAppearance()
        updateSearchBarAppearance()
    }
    
    func updateEmptyState(isEmpty: Bool, isSearching: Bool) {
        emptyStateLabel.isHidden = !isEmpty
        emptyStateLabel.text = isSearching ? Constants.Strings.cardsDidNotFound : Constants.Strings.emptyCards
    }
    
    func setCollectionTitle(_ title: String) {
        titleLabel.text = title
    }
}

// MARK: - Private Methods

private extension CollectionDetailView {
    func updateSearchContainerAppearance() {
        searchContainerView.applyGlassEffect(cornerRadius: Constants.Layout.cornerRadiusSmall)
    }
    
    func updateSearchBarAppearance() {
        if ThemeManager.shared.currentTheme == .dark {
            searchBar.searchTextField.textColor = .ypWhite
            searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
                string: Constants.Strings.searchPlaceholder,
                attributes: [.foregroundColor: UIColor.ypLightGray]
            )
            searchBar.searchTextField.leftView?.tintColor = .ypLightGray
            searchBar.tintColor = .ypWhite
        } else {
            searchBar.searchTextField.textColor = .ypDarkGray
            searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
                string: Constants.Strings.searchPlaceholder,
                attributes: [.foregroundColor: UIColor.ypLightGray]
            )
            searchBar.searchTextField.leftView?.tintColor = .ypLightGray
            searchBar.tintColor = .ypDarkGray
        }
    }
}

// MARK: - Private SetupUI Methods

private extension CollectionDetailView {
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        backgroundColor = .clear
        
        searchContainerView.addSubview(searchBar)
        addSubview(backButton)
        addSubview(titleLabel)
        addSubview(addButton)
        addSubview(searchContainerView)
        addSubview(tableView)
        addSubview(emptyStateLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.Layout.defaultPadding),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Layout.defaultPadding),
            backButton.widthAnchor.constraint(equalToConstant: Constants.Layout.buttonSize),
            backButton.heightAnchor.constraint(equalToConstant: Constants.Layout.buttonSize),
            
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 2),
            titleLabel.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -Constants.Layout.compactPadding),
            
            addButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.Layout.defaultPadding),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Layout.defaultPadding),
            addButton.widthAnchor.constraint(equalToConstant: Constants.Layout.buttonSize),
            addButton.heightAnchor.constraint(equalToConstant: Constants.Layout.buttonSize),
            
            searchContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            searchContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Layout.defaultPadding),
            searchContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Layout.defaultPadding),
            searchContainerView.heightAnchor.constraint(equalToConstant: Constants.Layout.searchBarHeight),
            
            searchBar.topAnchor.constraint(equalTo: searchContainerView.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor, constant: Constants.Layout.smallPadding),
            searchBar.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor, constant: -Constants.Layout.smallPadding),
            searchBar.bottomAnchor.constraint(equalTo: searchContainerView.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: Constants.Layout.defaultPadding),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            emptyStateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40)
        ])
    }
}
