//
//  BaseView.swift
//  Keep
//
//  Created by admin on 20.11.2025.
//

import UIKit

class BaseView: UIView, ThemeableView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(font: Typography.titleLabel.font, alignment: .left, textColor: .ypWhite)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let searchContainerView: UIView = {
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
    
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = .clear
        searchContainerView.addSubview(searchBar)
        addSubview(titleLabel)
        addSubview(searchContainerView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.Layout.defaultPadding),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Layout.defaultPadding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Layout.defaultPadding),
            
            searchContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            searchContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Layout.defaultPadding),
            searchContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Layout.defaultPadding),
            searchContainerView.heightAnchor.constraint(equalToConstant: Constants.Layout.searchBarHeight),
            
            searchBar.topAnchor.constraint(equalTo: searchContainerView.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor, constant: Constants.Layout.smallPadding),
            searchBar.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor, constant: -Constants.Layout.smallPadding),
            searchBar.bottomAnchor.constraint(equalTo: searchContainerView.bottomAnchor)
        ])
    }
    
    func updateAppearance() {
        applyThemeBackgroundGradient()
        updateSearchContainerAppearance()
        updateSearchBarAppearance()
    }
    
    private func updateSearchContainerAppearance() {
        searchContainerView.applyGlassEffect(cornerRadius: Constants.Layout.cornerRadiusSmall)
    }
    
    private func updateSearchBarAppearance() {
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
