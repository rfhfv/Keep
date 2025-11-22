//
//  TrainingView.swift
//  Keep
//
//  Created by admin on 13.11.2025.
//

import UIKit

protocol TrainingViewProtocol: ThemeableView, EmptyStateView {
    var tableView: UITableView { get }
    var searchBar: UISearchBar { get }
    
    func updateEmptyState(isEmpty: Bool, isSearching: Bool)
}

final class TrainingView: BaseView, TrainingViewProtocol {
    let tableView: UITableView = {
        let table = UITableView()
        table.register(TrainingCollectionCell.self, forCellReuseIdentifier: Constants.Identifiers.trainingCell)
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
    
    init() {
        super.init(title: Constants.Strings.training)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        super.setupUI()
        addSubview(tableView)
        addSubview(emptyStateLabel)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: Constants.Layout.defaultPadding),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 30),
            emptyStateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            emptyStateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40)
        ])
    }
    
    func updateEmptyState(isEmpty: Bool, isSearching: Bool) {
        emptyStateLabel.isHidden = !isEmpty
        emptyStateLabel.text = isSearching ? Constants.Strings.trainingCollectionsDidNotFound : Constants.Strings.emptyTraining
    }
}
