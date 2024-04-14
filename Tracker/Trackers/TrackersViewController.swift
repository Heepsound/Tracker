//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Владимир Горбачев on 06.04.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "AddTracker"), for: .normal)
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        return button
    }()
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.timeZone = NSTimeZone.local
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return datePicker
    }()
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.textColor = .trackerBlack
        label.font = UIFont.boldSystemFont(ofSize: 34)
        return label
    }()
    private var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Поиск"
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    private var workAreaStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    private var noTrackersImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "TrackerError")
        return imageView
    }()
    private var noTrackersLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.textColor = .trackerBlack
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    private var collectionViewCell: UICollectionViewCell = {
        let collectionViewCell = UICollectionViewCell()
        return collectionViewCell
    }()
        
    private var currentDate: Date = Date()
    
    private var trackerService = TrackerService.shared
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTrackerViewController()
        datePicker.date = Date()
        collectionView.dataSource = self
    }
    
    private func setupTrackerViewController() {
        view.backgroundColor = .trackerWhite
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        addSubViews()
        applyConstraints()
    }
    
    private func addSubViews() {
        view.addSubviewWithoutAutoresizingMask(addButton)
        view.addSubviewWithoutAutoresizingMask(datePicker)
        view.addSubviewWithoutAutoresizingMask(titleLabel)
        view.addSubviewWithoutAutoresizingMask(searchBar)
        view.addSubviewWithoutAutoresizingMask(workAreaStackView)
        workAreaStackView.addSubviewWithoutAutoresizingMask(collectionView)
        workAreaStackView.addSubviewWithoutAutoresizingMask(noTrackersImageView)
        workAreaStackView.addSubviewWithoutAutoresizingMask(noTrackersLabel)
    }

    private func applyConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 41),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        NSLayoutConstraint.activate([
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
        NSLayoutConstraint.activate([
            workAreaStackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            workAreaStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            workAreaStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            workAreaStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            noTrackersImageView.heightAnchor.constraint(equalToConstant: 80),
            noTrackersImageView.widthAnchor.constraint(equalToConstant: 80),
            noTrackersImageView.centerXAnchor.constraint(equalTo: workAreaStackView.centerXAnchor),
            noTrackersImageView.centerYAnchor.constraint(equalTo: workAreaStackView.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            noTrackersLabel.heightAnchor.constraint(equalToConstant: 18),
            noTrackersLabel.centerXAnchor.constraint(equalTo: workAreaStackView.centerXAnchor),
            noTrackersLabel.topAnchor.constraint(equalTo: noTrackersImageView.bottomAnchor, constant: 8)
        ])
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: workAreaStackView.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: workAreaStackView.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: workAreaStackView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: workAreaStackView.bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func didTapAddButton() {
        let trackerTypeViewController = TrackerTypeViewController()
        self.present(trackerTypeViewController, animated: true)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
    }
}

// MARK: - Extensions

extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.contentView.backgroundColor = .red
        return cell
    }
}
