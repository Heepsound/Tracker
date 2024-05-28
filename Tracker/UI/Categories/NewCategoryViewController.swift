//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Владимир Горбачев on 27.04.2024.
//

import UIKit

final class NewCategoryViewController: UIViewController {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.isEditMode ?
            NSLocalizedString("newCategory.editTitle", comment: "Заголовок экрана редактирования категории") :
            NSLocalizedString("newCategory.title", comment: "Заголовок экрана создания категории")
        label.textColor = .trackerBlack
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .trackerBlack
        textField.borderStyle = .none
        textField.placeholder = NSLocalizedString("newCategory.categoryName.placeholder", comment: "Подсказка ввода названия категории")
        textField.backgroundColor = .trackerFieldAlpha30
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.delegate = self
        textField.addTarget(self, action: #selector(nameTextFieldDidChange(_:)), for: .editingChanged)
        return textField
    }()
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .trackerGray
        button.isEnabled = false
        let buttonTitle = NSLocalizedString("newCategory.addButton.title", comment: "Заголовок кнопки подтверждения создания новой категории")
        button.setTitle(buttonTitle, for: .normal)
        button.setTitleColor(.trackerWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: EntityEditViewControllerDelegate?
    private let viewModel: NewCategoryViewModel = NewCategoryViewModel()
    
    // MARK: - Lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize(indexPath: IndexPath) {
        viewModel.indexPath = indexPath
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNewCategoryViewController()
    }
    
    private func setupNewCategoryViewController() {
        view.backgroundColor = .trackerWhite
        if let categoryName = viewModel.categoryName {
            nameTextField.text = categoryName
        }
        addSubViews()
        applyConstraints()
    }
    
    private func addSubViews() {
        [titleLabel, nameTextField, addButton].forEach { subview in
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
    
    private func bind() {
        viewModel.allDataEntered = { [weak self] allDataEntered in
            self?.addButton.isEnabled = allDataEntered
            self?.addButton.backgroundColor = allDataEntered ? UIColor.trackerBlack : UIColor.trackerGray
        }
    }
    
    // MARK: - Actions
    
    @objc private func didTapAddButton() {
        viewModel.save()
        delegate?.editingСompleted(nil)
    }
    
    @objc private func nameTextFieldDidChange(_ sender: UITextField) {
        viewModel.categoryName = sender.text
    }
}

// MARK: - UITextFieldDelegate

extension NewCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

