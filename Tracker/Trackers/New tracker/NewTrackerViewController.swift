//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by Владимир Горбачев on 14.04.2024.
//

import UIKit

final class NewTrackerViewController: UIViewController {
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .trackerBlack
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    private var nameTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .trackerBlack
        textField.borderStyle = .none
        textField.placeholder = "Введите название трекера"
        textField.backgroundColor = .trackerFieldBackground
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return textField
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .trackerFieldBackground
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 16
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.reuseIdentifier)
        return tableView
    }()
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .trackerGray
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.trackerWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        return button
    }()
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .trackerWhite
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.trackerPink, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.trackerPink.cgColor
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return button
    }()
    private var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()

    private var trackerService = TrackerService.shared
    private var categoryRowsCount: Int = 0
    
    var dismissClosure: (() -> Void)?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNewTrackerViewController()
    }
    
    private func setupNewTrackerViewController() {
        view.backgroundColor = .trackerWhite
        if trackerService.newTrackerType == .habit {
            titleLabel.text = "Новая привычка"
        } else {
            titleLabel.text = "Новое нерегулярное событие"
        }
        if let trackerType = trackerService.newTrackerType {
            categoryRowsCount = trackerType == .irregularEvent ? 1 : 2
        }
        let indexPaths = (0..<categoryRowsCount).map { i in
            IndexPath(row: i, section: 0)
        }
        tableView.insertRows(at: indexPaths, with: .automatic)
        tableView.reloadData()
        addSubViews()
        applyConstraints()
    }
    
    private func addSubViews() {
        view.addSubviewWithoutAutoresizingMask(titleLabel)
        view.addSubviewWithoutAutoresizingMask(nameTextField)
        view.addSubviewWithoutAutoresizingMask(tableView)
        view.addSubviewWithoutAutoresizingMask(buttonsStackView)
        buttonsStackView.addArrangedSubview(cancelButton)
        buttonsStackView.addArrangedSubview(addButton)
    }

    private func applyConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 28)
        ])
        NSLayoutConstraint.activate([
            nameTextField.widthAnchor.constraint(equalToConstant: 343),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38)
        ])
        NSLayoutConstraint.activate([
            tableView.widthAnchor.constraint(equalToConstant: 343),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(categoryRowsCount * 75)),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24)
        ])
        NSLayoutConstraint.activate([
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            cancelButton.widthAnchor.constraint(equalToConstant: 166),
            cancelButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        NSLayoutConstraint.activate([
            addButton.widthAnchor.constraint(equalToConstant: 161),
            addButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func didTapAddButton() {
        
    }
    
    @objc private func didTapCancelButton() {
        trackerService.clearNewTrackerData()
        dismiss(animated: true)
        dismissClosure?()
    }
}

extension NewTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryRowsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseIdentifier, for: indexPath)
        guard let cell = cell as? CategoryCell else {
            return UITableViewCell()
        }
        cell.isSchedule = indexPath.row == 1
        if indexPath.row == categoryRowsCount - 1 {
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

extension NewTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let scheduleViewController = ScheduleViewController()
            scheduleViewController.dismissClosure = { [weak self] in
                self?.trackerService.newTrackerSchedule.sort(by: {$0.dayNumber < $1.dayNumber})
                self?.tableView.reloadData()
            }
            self.present(scheduleViewController, animated: true)
        } else {
            
        }
    }
}
