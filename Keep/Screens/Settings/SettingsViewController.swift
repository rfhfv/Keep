//
//  SettingsViewController.swift
//  Keep
//
//  Created by admin on 13.11.2025.
//

import UIKit

final class SettingsViewController: UIViewController {
    private lazy var contentView = SettingsView()
    private let viewModel: SettingsViewModelProtocol
    private let coordinator: SettingsCoordinator
    
    init(viewModel: SettingsViewModelProtocol, coordinator: SettingsCoordinator) {
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return ThemeManager.shared.currentTheme == .dark ? .lightContent : .darkContent
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Private Methods

private extension SettingsViewController {
    func setupDelegates() {
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        contentView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.Identifiers.settingsCell)
    }
    
    func setupTheme() {
        view.applyThemeBackgroundGradient()
        
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("ThemeDidChange"),
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateAppearance()
        }
    }
    
    func updateAppearance() {
        contentView.updateAppearance()
        contentView.tableView.reloadData()
    }
}

// MARK: - UITableView Delegate & DataSource

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return viewModel.themesCount
        case 1: return 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = ThemeManager.shared.currentTheme == .dark ? UIColor.ypWhite : UIColor.ypWhite
        
        switch section {
        case 0: label.text = "ТЕМА"
        case 1: label.text = "О ПРИЛОЖЕНИИ"
        default: break
        }
        
        headerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.settingsCell, for: indexPath)
        
        cell.accessoryType = .none
        cell.selectionStyle = .default
        cell.backgroundColor = .clear
        
        let cornerRadius: CGFloat = Constants.Layout.cornerRadiusSmall
        cell.applyGlassEffect(cornerRadius: cornerRadius)
        cell.layer.maskedCorners = [
            .layerMinXMinYCorner, .layerMaxXMinYCorner,
            .layerMinXMaxYCorner, .layerMaxXMaxYCorner
        ]
        
        switch indexPath.section {
        case 0:
            let theme = viewModel.themes[indexPath.row]
            cell.textLabel?.text = viewModel.themeName(at: indexPath.row)
            cell.accessoryType = theme == viewModel.currentTheme ? .checkmark : .none
            
        case 1:
            cell.textLabel?.text = viewModel.appVersion
            cell.selectionStyle = .none
            cell.textLabel?.textColor = ThemeManager.shared.currentTheme == .dark ? .ypLightGray : .ypDarkGray
            
        default:
            break
        }
        
        if ThemeManager.shared.currentTheme == .dark {
            cell.textLabel?.textColor = .ypWhite
            cell.tintColor = .ypWhite
        } else {
            cell.textLabel?.textColor = .ypDarkGray
            cell.tintColor = .ypDarkGray
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            if let selectedTheme = viewModel.theme(at: indexPath.row) {
                viewModel.setTheme(selectedTheme)
                updateAppearance()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
