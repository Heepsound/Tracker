//
//  TrackerTypeViewController.swift
//  Tracker
//
//  Created by Владимир Горбачев on 14.04.2024.
//

import UIKit

final class TrackerTypeViewController: UIViewController {
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Создание трекера"
        label.textColor = .trackerBlack
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    private lazy var addHabitButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .trackerBlack
        button.setTitle("Привычка", for: .normal)
        button.setTitleColor(.trackerWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapAddHabitButton), for: .touchUpInside)
        return button
    }()
    private lazy var addIrregularEventButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .trackerBlack
        button.setTitle("Нерегулярное событие", for: .normal)
        button.setTitleColor(.trackerWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapAddIrregularEventButton), for: .touchUpInside)
        return button
    }()
    private var workAreaStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        return stackView
    }()
    
    private var trackerService = TrackerService.shared
    weak var delegate: NewTrackerViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTrackerTypeViewController()
    }
    
    private func setupTrackerTypeViewController() {
        view.backgroundColor = .trackerWhite
        addSubViews()
        applyConstraints()
    }
    
    private func addSubViews() {
        view.addSubviewWithoutAutoresizingMask(titleLabel)
        view.addSubviewWithoutAutoresizingMask(workAreaStackView)
        workAreaStackView.addArrangedSubview(addHabitButton)
        workAreaStackView.addArrangedSubview(addIrregularEventButton)
    }

    private func applyConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 28)
        ])
        NSLayoutConstraint.activate([
            workAreaStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            workAreaStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 44)
        ])
        NSLayoutConstraint.activate([
            addHabitButton.widthAnchor.constraint(equalToConstant: 335),
            addHabitButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        NSLayoutConstraint.activate([
            addIrregularEventButton.widthAnchor.constraint(equalToConstant: 335),
            addIrregularEventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func showNewTrackerViewController(trackerType: TrackerTypes) {
        trackerService.newTrackerType = trackerType
        let newTrackerViewController = NewTrackerViewController()
        newTrackerViewController.delegate = self.delegate
        self.present(newTrackerViewController, animated: true)
    }
    
    // MARK: - Actions
    
    @objc private func didTapAddHabitButton() {
        showNewTrackerViewController(trackerType: .habit)
    }
    
    @objc private func didTapAddIrregularEventButton() {
        showNewTrackerViewController(trackerType: .irregularEvent)
    }
}
