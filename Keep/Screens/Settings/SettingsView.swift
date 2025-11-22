//
//  SettingsView.swift
//  Keep
//
//  Created by admin on 13.11.2025.
//

import UIKit

protocol SettingsViewProtocol: ThemeableView {
    var tableView: UITableView { get }
}

final class SettingsView: UIView, SettingsViewProtocol {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(font: Typography.titleLabel.font, alignment: .left, textColor: .ypWhite)
        label.text = Constants.Strings.settings
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.sectionHeaderHeight = 0
        table.sectionFooterHeight = 0
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
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
    }
}

// MARK: - Private SetupUI Methods

private extension SettingsView {
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        backgroundColor = .clear
        addSubview(titleLabel)
        addSubview(tableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.Layout.defaultPadding),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Layout.defaultPadding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Layout.defaultPadding),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Layout.defaultPadding),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Layout.defaultPadding),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
