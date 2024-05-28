//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Владимир Горбачев on 14.04.2024.
//

import UIKit

final class ScheduleViewController: UIViewController {
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("schedule.title", comment: "Заголовок экрана")
        label.textColor = .trackerText
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorColor = .trackerSeparator
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 16
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: ScheduleCell.reuseIdentifier)
        return tableView
    }()
    private lazy var confirmButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .trackerButtonBackground
        let buttonTitle = NSLocalizedString("schedule.confirmButton.title", comment: "Заголовок кнопки подтверждения расписания")
        button.setTitle(buttonTitle, for: .normal)
        button.setTitleColor(.trackerButtonText, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        return button
    }()
    
    var schedule: [DaysOfWeek] = []
    
    var dismissClosure: ((_ schedule: [DaysOfWeek]) -> Void)?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScheduleViewController()
    }
    
    private func setupScheduleViewController() {
        view.backgroundColor = .trackerBackground
        let indexPaths = (0...6).map { i in
            IndexPath(row: i, section: 0)
        }
        tableView.insertRows(at: indexPaths, with: .automatic)
        tableView.reloadData()
        addSubViews()
        applyConstraints()
    }
    
    private func addSubViews() {
        [titleLabel, tableView, confirmButton].forEach { subview in
            view.addSubviewWithoutAutoresizingMask(subview)
        }
    }

    private func applyConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 28)
        ])
        NSLayoutConstraint.activate([
            tableView.widthAnchor.constraint(equalToConstant: 343),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(7 * 75)),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30)
        ])
        NSLayoutConstraint.activate([
            confirmButton.widthAnchor.constraint(equalToConstant: 335),
            confirmButton.heightAnchor.constraint(equalToConstant: 60),
            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func didTapConfirmButton() {
        dismissClosure?(schedule)
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleCell.reuseIdentifier, for: indexPath)
        guard let cell = cell as? ScheduleCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.dayOfWeek = DaysOfWeek(rawValue: indexPath.row + 1)
        if indexPath.row == 6 {
            cell.separatorInset.left = 1000
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

// MARK: - UITableViewDelegate

extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

// MARK: - ScheduleCellDelegate

extension ScheduleViewController: ScheduleCellDelegate {
    func add(_ dayOfWeek: DaysOfWeek) {
        schedule.append(dayOfWeek)
    }
    
    func delete(_ dayOfWeek: DaysOfWeek) {
        if let index = schedule.firstIndex(of: dayOfWeek) {
            schedule.remove(at: index)
        }
    }
}
