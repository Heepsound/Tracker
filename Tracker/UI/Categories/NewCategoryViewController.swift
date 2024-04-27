//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Владимир Горбачев on 27.04.2024.
//

import UIKit

final class NewCategoryViewController: UIViewController {
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая категория"
        label.textColor = .trackerBlack
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .trackerBlack
        textField.borderStyle = .none
        textField.placeholder = "Введите название категории"
        textField.backgroundColor = .trackerFieldAlpha30
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.addTarget(self, action: #selector(nameTextFieldDidChange(_:)), for: .editingChanged)
        return textField
    }()
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .trackerGray
        button.isEnabled = false
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.trackerWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        return button
    }()
    
    private var trackerService = TrackerService.shared
    weak var delegate: NewCategoryViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNewCategoryViewController()
        trackerService.newCategoryDelegate = self
    }
    
    private func setupNewCategoryViewController() {
        view.backgroundColor = .trackerWhite
        addSubViews()
        applyConstraints()
    }
    
    private func addSubViews() {
        view.addSubviewWithoutAutoresizingMask(titleLabel)
        view.addSubviewWithoutAutoresizingMask(nameTextField)
        view.addSubviewWithoutAutoresizingMask(addButton)
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
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30)
        ])
        NSLayoutConstraint.activate([
            addButton.widthAnchor.constraint(equalToConstant: 335),
            addButton.heightAnchor.constraint(equalToConstant: 60),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func didTapAddButton() {
        trackerService.addNewCategory()
        delegate?.newCategoryCreateCompleted()
        self.dismiss(animated: true)
    }
    
    @objc private func nameTextFieldDidChange(_ sender: UITextField) {
        trackerService.newCategoryName = sender.text
    }
}

// MARK: - Extensions

extension NewCategoryViewController: TrackerServiceNewCategoryDelegate {
    func newCategoryDataChanged(_ allDataEntered: Bool) {
        addButton.isEnabled = allDataEntered
        addButton.backgroundColor = allDataEntered ? UIColor.trackerBlack : UIColor.trackerGray
    }
}

