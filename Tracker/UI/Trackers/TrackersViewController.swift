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
        datePicker.backgroundColor = .datePickerBackground
        datePicker.layer.cornerRadius = 8
        datePicker.layer.masksToBounds = true
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.timeZone = NSTimeZone.local
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return datePicker
    }()
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("trackers.title", comment: "Заголовок экрана")
        label.textColor = .trackerBlack
        label.font = UIFont.boldSystemFont(ofSize: 34)
        return label
    }()
    private lazy var searchTextField: UISearchTextField = {
        let searchTextField = UISearchTextField()
        searchTextField.backgroundColor = .searchFieldBackground
        searchTextField.placeholder = NSLocalizedString("trackers.searchBar.placeholder", comment: "Подсказка поиска")
        searchTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        return searchTextField
    }()
    private var workAreaStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    private var noTrackersImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private var noTrackersLabel: UILabel = {
        let label = UILabel()
        label.textColor = .trackerBlack
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.allowsMultipleSelection = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.reuseIdentifier)
        collectionView.register(TrackerHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerHeaderView.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
        
    private let viewModel: TrackerViewModel = TrackerViewModel()
    
    private var searchActive: Bool = false {
        didSet {
            if searchActive {
                noTrackersLabel.text = NSLocalizedString("trackers.noTrackersFoundLabel", comment: "Текст при отсутствии трекеров в результате поиска")
                noTrackersImageView.image = UIImage(named: "SearchError")
            } else {
                noTrackersLabel.text = NSLocalizedString("trackers.noTrackersLabel", comment: "Текст при отсутствии трекеров")
                noTrackersImageView.image = UIImage(named: "TrackerError")
            }
        }
    }
    
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
        setupTrackerViewController()
        datePicker.date = Date()
        viewModel.trackersDate = datePicker.date
    }
    
    private func setupTrackerViewController() {
        searchActive = false
        view.backgroundColor = .trackerWhite
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        addSubViews()
        applyConstraints()
    }
    
    private func addSubViews() {
        [addButton, datePicker, titleLabel, searchTextField, workAreaStackView].forEach { subview in
            view.addSubviewWithoutAutoresizingMask(subview)
        }
        [noTrackersImageView, noTrackersLabel, collectionView].forEach { subview in
            workAreaStackView.addSubviewWithoutAutoresizingMask(subview)
        }
    }

    private func applyConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 41),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        NSLayoutConstraint.activate([
            searchTextField.heightAnchor.constraint(equalToConstant: 36),
            searchTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        NSLayoutConstraint.activate([
            workAreaStackView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
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
    
    private func bind() {
        viewModel.updateData = { [weak self] update in
            if !update.updatedIndexPaths.isEmpty {
                self?.collectionView.reloadItems(at: update.updatedIndexPaths)
            } else {
                self?.updateTrackers()
            }
        }
    }
    
    func updateTrackers() {
        collectionView.reloadData()
        let hasData = viewModel.hasData
        collectionView.isHidden = !hasData
    }
    
    // MARK: - Actions
    
    @objc private func didTapAddButton() {
        let trackerTypeViewController = TrackerTypeViewController()
        trackerTypeViewController.delegate = self
        self.present(trackerTypeViewController, animated: true)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        viewModel.trackersDate = sender.date
    }
    
    @objc func textDidChange(_ searchField: UISearchTextField) {
        if let searchText = searchField.text, !searchText.isEmpty {
            viewModel.trackersFilter = searchText
            if searchActive != true {
                searchActive = true
            }
        } else {
            viewModel.trackersFilter = ""
            if searchActive != false {
                searchActive = false
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.reuseIdentifier, for: indexPath)
        guard let cell = cell as? TrackerCell else {
            return UICollectionViewCell()
        }
        cell.viewModel = viewModel
        cell.indexPath = indexPath
        cell.tracker = viewModel.model(at: indexPath)
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackerHeaderView.reuseIdentifier, for: indexPath)
            guard let view = view as? TrackerHeaderView else {
                return UICollectionViewCell()
            }
            view.title = viewModel.categoryName(at: indexPath)
            return view
        case UICollectionView.elementKindSectionFooter:
            return UICollectionReusableView()
        default:
            return UICollectionReusableView()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 167, height: 148)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
}

// MARK: - UICollectionViewDelegate

extension TrackersViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemsAt indexPaths: [IndexPath],
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        guard indexPaths.count > 0 else { return nil }
        let indexPath = indexPaths[0]
        let model = viewModel.model(at: indexPath)
        
        let pinTitle = NSLocalizedString("trackers.menu.pin", comment: "Заголовок действия - Прикрепить")
        let unpinTitle = NSLocalizedString("trackers.menu.unpin", comment: "Заголовок действия - Открепить")
        let editTitle = NSLocalizedString("trackers.menu.edit", comment: "Заголовок действия - Редактировать")
        let deleteTitle = NSLocalizedString("deleteButton.title", comment: "Заголовок действия - Удалить")
        
        return UIContextMenuConfiguration(actionProvider: { actions in
            return UIMenu(children: [
                UIAction(title: model.pinned ? unpinTitle : pinTitle) { [weak self] _ in
                    self?.viewModel.setPinned(at: indexPath)
                },
                UIAction(title: editTitle) { [weak self] _ in
                    let newTrackerViewController = NewTrackerViewController()
                    newTrackerViewController.initialize(indexPath: indexPath)
                    newTrackerViewController.delegate = self
                    self?.present(newTrackerViewController, animated: true)
                },
                UIAction(title: deleteTitle, attributes: [.destructive]) { [weak self] _ in
                    let alertTitle = NSLocalizedString("trackers.deleteAlert.title", comment: "Заголовок подтверждения удаления трекера")
                    AlertPresenter.confirmDelete(title: alertTitle, delegate: self) {
                        self?.viewModel.delete(indexPath: indexPath)
                    }
                }
            ])
        })
    }
}

// MARK: - EntityEditViewControllerDelegate

extension TrackersViewController: EntityEditViewControllerDelegate {
    func editingСompleted() {
        viewModel.getOnDate()
        self.dismiss(animated: true)
    }
}


