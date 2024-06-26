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
        label.text = NSLocalizedString("trackerType.title" , comment: "Заголовок формы выбора типа трекера")
        label.textColor = .trackerText
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    private lazy var addHabitButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .trackerButtonBackground
        let buttonTitle = NSLocalizedString("habit" , comment: "Заголовок кнопки привычки")
        button.setTitle(buttonTitle, for: .normal)
        button.setTitleColor(.trackerButtonText, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapAddHabitButton), for: .touchUpInside)
        return button
    }()
    private lazy var addIrregularEventButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .trackerButtonBackground
        let buttonTitle = NSLocalizedString("irregularEvent" , comment: "Заголовок кнопки нерегулярного события")
        button.setTitle(buttonTitle, for: .normal)
        button.setTitleColor(.trackerButtonText, for: .normal)
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
    
    weak var delegate: EntityEditViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTrackerTypeViewController()
    }
    
    private func setupTrackerTypeViewController() {
        view.backgroundColor = .trackerBackground
        addSubViews()
        applyConstraints()
    }
    
    private func addSubViews() {
        [titleLabel, workAreaStackView].forEach { subview in
            view.addSubviewWithoutAutoresizingMask(subview)
        }
        [addHabitButton, addIrregularEventButton].forEach { subview in
            workAreaStackView.addArrangedSubview(subview)
        }
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
        let newTrackerViewController = NewTrackerViewController()
        newTrackerViewController.initialize(trackerType: trackerType)
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
