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
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .trackerBlack
        textField.borderStyle = .none
        textField.placeholder = NSLocalizedString("newTracker.trackerName.placeholder", comment: "Подсказка ввода названия трекера")
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
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .trackerFieldAlpha30
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 16
        tableView.register(TrackerTypeCell.self, forCellReuseIdentifier: TrackerTypeCell.reuseIdentifier)
        return tableView
    }()
    private lazy var emojisCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.allowsMultipleSelection = false
        collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.reuseIdentifier)
        collectionView.register(TrackerHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerHeaderView.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    private lazy var colorsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.allowsMultipleSelection = false
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.reuseIdentifier)
        collectionView.register(TrackerHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerHeaderView.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .trackerGray
        button.isEnabled = false
        let buttonTitle = viewModel.isEditMode ?
            NSLocalizedString("newTracker.saveButton.title", comment: "Заголовок кнопки сохранения отредактированного трекера") :
            NSLocalizedString("newTracker.addButton.title", comment: "Заголовок кнопки подтверждения создания нового трекера")
        button.setTitle(buttonTitle, for: .normal)
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
        let buttonTitle = NSLocalizedString("cancelButton.title", comment: "Заголовок кнопки отмены создания нового трекера")
        button.setTitle(buttonTitle, for: .normal)
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
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    
    weak var delegate: EntityEditViewControllerDelegate?
    private let viewModel: NewTrackerViewModel = NewTrackerViewModel()
    
    // MARK: - Lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize(trackerType: TrackerTypes) {
        viewModel.trackerType = trackerType
    }
    
    func initialize(indexPath: IndexPath) {
        viewModel.indexPath = indexPath
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNewTrackerViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if viewModel.isEditMode {
            emojisCollectionView.selectItem(at: viewModel.emojiIndexPath, animated: true, scrollPosition: .centeredVertically)
            colorsCollectionView.selectItem(at: viewModel.colorIndexPath, animated: true, scrollPosition: .centeredVertically)
        }
        let contentRect: CGRect = scrollView.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: contentRect.height)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.clearNewTrackerData()
    }
    
    private func setupNewTrackerViewController() {
        view.backgroundColor = .trackerWhite
        if let trackerName = viewModel.trackerName {
            nameTextField.text = trackerName
        }
        let newIrregularEvent = viewModel.isEditMode ?
            NSLocalizedString("newTracker.editIrregularEvent", comment: "Текст заголовка формы редактирования трекера с нерегулярным событием") :
            NSLocalizedString("newTracker.newIrregularEvent", comment: "Текст заголовка формы создания трекера с нерегулярным событием")
        let newHabit = viewModel.isEditMode ?
            NSLocalizedString("newTracker.editHabit", comment: "Текст заголовка формы редактирования трекера с привычкой") :
            NSLocalizedString("newTracker.newHabit", comment: "Текст заголовка формы создания трекера с привычкой")
        if let isIrregularEvent = viewModel.isIrregularEvent {
            titleLabel.text = isIrregularEvent ? newIrregularEvent : newHabit
        } else {
            titleLabel.text = newIrregularEvent
        }
        let indexPaths = (0..<viewModel.categoryRowsCount).map { i in
            IndexPath(row: i, section: 0)
        }
        tableView.insertRows(at: indexPaths, with: .automatic)
        tableView.reloadData()
        addSubViews()
        applyConstraints()
    }
    
    private func addSubViews() {
        [titleLabel, scrollView].forEach { subview in
            view.addSubviewWithoutAutoresizingMask(subview)
        }
        [nameTextField, tableView, emojisCollectionView, colorsCollectionView, buttonsStackView].forEach { subview in
            scrollView.addSubviewWithoutAutoresizingMask(subview)
        }
        [cancelButton, addButton].forEach { subview in
            buttonsStackView.addArrangedSubview(subview)
        }
    }

    private func applyConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 28)
        ])
        NSLayoutConstraint.activate([
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            nameTextField.widthAnchor.constraint(equalToConstant: 343),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.topAnchor.constraint(equalTo: scrollView.topAnchor)
        ])
        NSLayoutConstraint.activate([
            tableView.widthAnchor.constraint(equalToConstant: 343),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(viewModel.categoryRowsCount * 75)),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24)
        ])
        NSLayoutConstraint.activate([
            emojisCollectionView.widthAnchor.constraint(equalToConstant: 343),
            emojisCollectionView.heightAnchor.constraint(equalToConstant: 222),
            emojisCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emojisCollectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 24)
        ])
        NSLayoutConstraint.activate([
            colorsCollectionView.widthAnchor.constraint(equalToConstant: 343),
            colorsCollectionView.heightAnchor.constraint(equalToConstant: 222),
            colorsCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            colorsCollectionView.topAnchor.constraint(equalTo: emojisCollectionView.bottomAnchor, constant: 24)
        ])
        NSLayoutConstraint.activate([
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStackView.topAnchor.constraint(equalTo: colorsCollectionView.bottomAnchor, constant: 24)
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
    
    private func bind() {
        viewModel.allDataEntered = { [weak self] allDataEntered in
            self?.addButton.isEnabled = allDataEntered
            self?.addButton.backgroundColor = allDataEntered ? UIColor.trackerBlack : UIColor.trackerGray
        }
    }
    
    // MARK: - Actions
    
    @objc private func didTapAddButton() {
        viewModel.save()
        delegate?.editingСompleted()
    }
    
    @objc private func didTapCancelButton() {
        delegate?.editingСompleted()
    }
    
    @objc private func nameTextFieldDidChange(_ sender: UITextField) {
        viewModel.trackerName = sender.text
    }
}

// MARK: - UITextFieldDelegate

extension NewTrackerViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLenght = 38
        guard let text = textField.text else { return false }
        let updatedString = NSString(string: text).replacingCharacters(in: range, with: string)
        return updatedString.count <= maxLenght
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UITableViewDataSource

extension NewTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categoryRowsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackerTypeCell.reuseIdentifier, for: indexPath)
        guard let cell = cell as? TrackerTypeCell else {
            return UITableViewCell()
        }
        cell.viewModel = viewModel
        cell.isSchedule = indexPath.row == 1
        if indexPath.row == viewModel.categoryRowsCount - 1 {
            cell.separatorInset.left = 1000
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension NewTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let categoryViewController = CategoryViewController()
            categoryViewController.dismissClosure = { category in
                self.viewModel.trackerCategory = category
                self.tableView.reloadData()
            }
            self.present(categoryViewController, animated: true)
        } else {
            let scheduleViewController = ScheduleViewController()
            scheduleViewController.schedule = viewModel.trackerSchedule
            scheduleViewController.dismissClosure = { schedule in
                self.viewModel.trackerSchedule = schedule
                self.tableView.reloadData()
            }
            self.present(scheduleViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

// MARK: - UICollectionViewDataSource

extension NewTrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojisCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.reuseIdentifier, for: indexPath)
            guard let cell = cell as? EmojiCell else {
                return UICollectionViewCell()
            }
            cell.emoji = viewModel.emojis[indexPath.row]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.reuseIdentifier, for: indexPath)
            guard let cell = cell as? ColorCell else {
                return UICollectionViewCell()
            }
            cell.hexColor = viewModel.colors[indexPath.row]
            return cell
        }
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
            if collectionView == emojisCollectionView {
                view.title = "Emoji"
            } else {
                view.title = NSLocalizedString("newTracker.colorCollection.title", comment: "Текст заголовка коллекции цветов")
            }
            return view
        case UICollectionView.elementKindSectionFooter:
            return UICollectionReusableView()
        default:
            return UICollectionReusableView()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension NewTrackerViewController: UICollectionViewDelegateFlowLayout {
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
        return CGSize(width: 52, height: 52)
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

extension NewTrackerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == emojisCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as? EmojiCell
            viewModel.trackerEmoji = cell?.emoji
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as? ColorCell
            viewModel.trackerColor = cell?.hexColor
        }
    }
}

