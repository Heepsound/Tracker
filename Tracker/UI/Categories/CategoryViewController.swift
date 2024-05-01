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
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .trackerFieldAlpha30
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 16
        tableView.autoresizingMask = .flexibleHeight
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
    
    private lazy var dataStore: TrackerCategoryStore = {
        let dataStore = TrackerCategoryStore()
        dataStore.delegate = self
        return dataStore
    }()
    
    var dismissClosure: ((_ category: TrackerCategoryCoreData?) -> Void)?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCategoryViewController()
        updateCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.layoutSubviews()
    }
    
    private func setupCategoryViewController() {
        view.backgroundColor = .trackerWhite
        addSubViews()
        applyConstraints()
    }
    
    private func addSubViews() {
        view.addSubviewWithoutAutoresizingMask(titleLabel)
        view.addSubviewWithoutAutoresizingMask(addCategoryButton)
        view.addSubviewWithoutAutoresizingMask(workAreaStackView)
        workAreaStackView.addSubviewWithoutAutoresizingMask(noCategoryImageView)
        workAreaStackView.addSubviewWithoutAutoresizingMask(noCategoryLabel)
        workAreaStackView.addSubviewWithoutAutoresizingMask(tableView)
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
            tableView.widthAnchor.constraint(equalToConstant: 343),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: workAreaStackView.topAnchor),
            tableView.bottomAnchor.constraint(lessThanOrEqualTo: workAreaStackView.bottomAnchor)
        ])
    }
    
    func updateCategories() {
        tableView.isHidden = dataStore.numberOfRowsInSection(0) == 0
        noCategoryLabel.isHidden = dataStore.numberOfRowsInSection(0) != 0
        noCategoryImageView.isHidden = dataStore.numberOfRowsInSection(0) != 0
    }
    
    // MARK: - Actions
    
    @objc private func didTapAddCategoryButton() {
        let newCategoryViewController = NewCategoryViewController()
        newCategoryViewController.delegate = self
        self.present(newCategoryViewController, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension CategoryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataStore.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataStore.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseIdentifier, for: indexPath)
        guard let cell = cell as? CategoryCell else {
            return UITableViewCell()
        }
        guard let record = dataStore.object(at: indexPath) else {
            return UITableViewCell()
        }
        cell.categoryName = record.name
        if indexPath.row == dataStore.numberOfRowsInSection(indexPath.section) - 1 {
            cell.separatorInset.left = 1000
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        dataStore.delete(at: indexPath)
    }
}

// MARK: - UITableViewDelegate

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismissClosure?(dataStore.object(at: indexPath))
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.layoutIfNeeded()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

// MARK: - NewCategoryViewControllerDelegate

extension CategoryViewController: NewCategoryViewControllerDelegate {
    func add(_ record: TrackerCategory) {
        dataStore.add(record)
    }
}

// MARK: - DataStoreDelegate

extension CategoryViewController: DataStoreDelegate {
    func didUpdate(_ update: DataStoreUpdate) {
        tableView.performBatchUpdates {
            tableView.insertRows(at: update.insertedIndexPaths, with: .automatic)
            tableView.deleteRows(at: update.deletedIndexPaths, with: .fade)
        }
        updateCategories()
    }
}
