//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Владимир Горбачев on 06.04.2024.
//

import UIKit

final class StatisticsViewController: UIViewController {
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("tabBar.statistics.title" , comment: "Заголовок формы статистики")
        label.textColor = .trackerText
        label.font = UIFont.boldSystemFont(ofSize: 34)
        return label
    }()
    private var workAreaStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    private var noStatisticsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "StatisticsError")
        return imageView
    }()
    private var noStatisticsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .trackerText
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = NSLocalizedString("statistics.noStatisticsLabel", comment: "Текст при отсутствии статистики")
        return label
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        tableView.layer.masksToBounds = true
        tableView.allowsMultipleSelection = false
        tableView.register(StatisticsCell.self, forCellReuseIdentifier: StatisticsCell.reuseIdentifier)
        return tableView
    }()
    
    private let viewModel: StatisticsViewModel = StatisticsViewModel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateStatistics()
    }
    
    private func setupViewController() {
        view.backgroundColor = .trackerBackground
        addSubViews()
        applyConstraints()
    }
    
    private func addSubViews() {
        [titleLabel, workAreaStackView].forEach { subview in
            view.addSubviewWithoutAutoresizingMask(subview)
        }
        [noStatisticsImageView, noStatisticsLabel, tableView].forEach { subview in
            workAreaStackView.addSubviewWithoutAutoresizingMask(subview)
        }
    }

    private func applyConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            workAreaStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            workAreaStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            workAreaStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            workAreaStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            noStatisticsImageView.heightAnchor.constraint(equalToConstant: 80),
            noStatisticsImageView.widthAnchor.constraint(equalToConstant: 80),
            noStatisticsImageView.centerXAnchor.constraint(equalTo: workAreaStackView.centerXAnchor),
            noStatisticsImageView.centerYAnchor.constraint(equalTo: workAreaStackView.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            noStatisticsLabel.heightAnchor.constraint(equalToConstant: 18),
            noStatisticsLabel.centerXAnchor.constraint(equalTo: workAreaStackView.centerXAnchor),
            noStatisticsLabel.topAnchor.constraint(equalTo: noStatisticsImageView.bottomAnchor, constant: 8)
        ])
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: workAreaStackView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: workAreaStackView.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: workAreaStackView.topAnchor),
            tableView.bottomAnchor.constraint(lessThanOrEqualTo: workAreaStackView.bottomAnchor)
        ])
    }
    
    func updateStatistics() {
        let hasData = viewModel.hasData
        tableView.isHidden = !hasData
        noStatisticsLabel.isHidden = hasData
        noStatisticsImageView.isHidden = hasData
    }
}

// MARK: - UITableViewDataSource

extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StatisticsCell.reuseIdentifier, for: indexPath)
        guard let cell = cell as? StatisticsCell else {
            return UITableViewCell()
        }
        let model = viewModel.model(at: indexPath)
        cell.trackersStatistics = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 102
    }
}

// MARK: - UITableViewDelegate

extension StatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
}
