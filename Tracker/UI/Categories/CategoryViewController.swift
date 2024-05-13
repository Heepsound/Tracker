//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Владимир Горбачев on 15.04.2024.
//

import UIKit

final class CategoryViewController: UIViewController {
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.textColor = .trackerBlack
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    private var workAreaStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    private var noCategoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "TrackerError")
        return imageView
    }()
    private var noCategoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Привычки и события можно \nобъединить по смыслу"
        label.textColor = .trackerBlack
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .insetGrouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 16
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.reuseIdentifier)
        return tableView
    }()
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .trackerBlack
        button.setTitle("Добавить категорию", for: .normal)
        button.setTitleColor(.trackerWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapAddCategoryButton), for: .touchUpInside)
        return button
    }()
    
    var dismissClosure: ((_ category: TrackerCategory?) -> Void)?
    private let viewModel: CategoryViewModel = CategoryViewModel()
    
    // MARK: - Lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCategoryViewController()
        updateCategories()
        
    }
    
    private func setupCategoryViewController() {
        view.backgroundColor = .trackerWhite
        addSubViews()
        applyConstraints()
    }
    
    private func addSubViews() {
        [titleLabel, addCategoryButton, workAreaStackView].forEach { subview in
            view.addSubviewWithoutAutoresizingMask(subview)
        }
        [noCategoryImageView, noCategoryLabel, tableView].forEach { subview in
            workAreaStackView.addSubviewWithoutAutoresizingMask(subview)
        }
    }

    private func applyConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 28)
        ])
        NSLayoutConstraint.activate([
            addCategoryButton.widthAnchor.constraint(equalToConstant: 335),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            addCategoryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            workAreaStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            workAreaStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            workAreaStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            workAreaStackView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -30)
        ])
        NSLayoutConstraint.activate([
            noCategoryImageView.heightAnchor.constraint(equalToConstant: 80),
            noCategoryImageView.widthAnchor.constraint(equalToConstant: 80),
            noCategoryImageView.centerXAnchor.constraint(equalTo: workAreaStackView.centerXAnchor),
            noCategoryImageView.centerYAnchor.constraint(equalTo: workAreaStackView.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            noCategoryLabel.centerXAnchor.constraint(equalTo: workAreaStackView.centerXAnchor),
            noCategoryLabel.topAnchor.constraint(equalTo: noCategoryImageView.bottomAnchor, constant: 8)
        ])
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: workAreaStackView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: workAreaStackView.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: workAreaStackView.topAnchor),
            tableView.bottomAnchor.constraint(lessThanOrEqualTo: workAreaStackView.bottomAnchor)
        ])
    }
    
    private func bind() {
        viewModel.updateData = { [weak self] update in
            self?.tableView.performBatchUpdates {
                self?.tableView.insertRows(at: update.insertedIndexPaths, with: .automatic)
                self?.tableView.deleteRows(at: update.deletedIndexPaths, with: .fade)
            }
            self?.updateCategories()
        }
    }
    
    func updateCategories() {
        let hasData = viewModel.hasData
        tableView.isHidden = !hasData
        noCategoryLabel.isHidden = hasData
        noCategoryImageView.isHidden = hasData
    }
    
    // MARK: - Actions
    
    @objc private func didTapAddCategoryButton() {
        let newCategoryViewController = NewCategoryViewController()
        self.present(newCategoryViewController, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension CategoryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseIdentifier, for: indexPath)
        guard let cell = cell as? CategoryCell, let model = viewModel.model(at: indexPath) else {
            return UITableViewCell()
        }
        cell.categoryName = model.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        viewModel.delete(at: indexPath)
    }
}

// MARK: - UITableViewDelegate

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismissClosure?(viewModel.model(at: indexPath))
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}


