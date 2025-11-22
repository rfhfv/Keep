//
//  CollectionsView.swift
//  Keep
//
//  Created by admin on 13.11.2025.
//

import UIKit

protocol CollectionsViewProtocol: ThemeableView, EmptyStateView {
    var collectionView: UICollectionView { get }
    var searchBar: UISearchBar { get }
    var addButton: UIButton { get }
    
    func updateEmptyState(isEmpty: Bool, isSearching: Bool)
}

final class CollectionsView: BaseView, CollectionsViewProtocol {
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .ypWhite
        button.setImage(UIImage(systemName: Constants.Images.plus), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout:  CollectionsView.createLayout())
        collectionView.backgroundColor = .clear
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: Constants.Identifiers.collectionCell)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(font: Typography.emptyState.font, textColor: .ypWhite)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init() {
        super.init(title: Constants.Strings.collections)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateEmptyState(isEmpty: Bool, isSearching: Bool) {
        emptyStateLabel.isHidden = !isEmpty
        emptyStateLabel.text = isSearching ? Constants.Strings.collectionsDidNotFound : Constants.Strings.emptyCollections
    }
    
    private static func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        let totalSpacing = Constants.Layout.defaultPadding * 3
        let availableWidth = UIScreen.main.bounds.width - totalSpacing
        let cellWidth = availableWidth / 2
        
        layout.itemSize = CGSize(
            width: cellWidth,
            height: Constants.Layout.collectionCellHeight
        )
        
        layout.minimumInteritemSpacing = Constants.Layout.defaultPadding
        layout.minimumLineSpacing = Constants.Layout.defaultPadding
        layout.sectionInset = UIEdgeInsets(
            top: Constants.Layout.defaultPadding,
            left: Constants.Layout.defaultPadding,
            bottom: Constants.Layout.extraLargePadding,
            right: Constants.Layout.defaultPadding
        )
        return layout
    }
    
    override func setupUI() {
        super.setupUI()
        addSubview(addButton)
        addSubview(collectionView)
        addSubview(emptyStateLabel)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.Layout.defaultPadding),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Layout.defaultPadding),
            addButton.widthAnchor.constraint(equalToConstant: Constants.Layout.buttonSize),
            addButton.heightAnchor.constraint(equalToConstant: Constants.Layout.buttonSize),
            
            collectionView.topAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: Constants.Layout.defaultPadding),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 24),
            emptyStateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            emptyStateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40)
        ])
    }
}
