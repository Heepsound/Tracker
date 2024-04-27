//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Владимир Горбачев on 15.04.2024.
//

import UIKit

protocol NewCategoryViewControllerDelegate: AnyObject {
    func newCategoryCreateCompleted()
}

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
    
    private var trackerService = TrackerService.shared
    
    var dismissClosure: (() -> Void)?
    
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
        let indexPaths = (0..<trackerService.categories.count).map { i in
            IndexPath(row: i, section: 0)
        }
        tableView.insertRows(at: indexPaths, with: .automatic)
        tableView.reloadData()
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
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(75)),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: workAreaStackView.topAnchor),
            tableView.bottomAnchor.constraint(lessThanOrEqualTo: workAreaStackView.bottomAnchor)
        ])
    }
    
    func updateCategories() {
        tableView.isHidden = trackerService.categories.isEmpty
        noCategoryLabel.isHidden = !trackerService.categories.isEmpty
        noCategoryImageView.isHidden = !trackerService.categories.isEmpty
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @objc private func didTapAddCategoryButton() {
        let newCategoryViewController = NewCategoryViewController()
        newCategoryViewController.delegate = self
        self.present(newCategoryViewController, animated: true)
    }
}

// MARK: - Extensions

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackerService.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseIdentifier, for: indexPath)
        guard let cell = cell as? CategoryCell else {
            return UITableViewCell()
        }
        cell.categoryName = trackerService.categories[indexPath.row].name
        if indexPath.row == trackerService.categories.count - 1 {
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

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        trackerService.newTrackerCategory = trackerService.categories[indexPath.row].name
        dismissClosure?()
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.layoutIfNeeded()
    }
}

extension CategoryViewController: NewCategoryViewControllerDelegate {
    func newCategoryCreateCompleted() {
        updateCategories()
    }
}
