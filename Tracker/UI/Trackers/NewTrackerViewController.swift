//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by Владимир Горбачев on 14.04.2024.
//

import UIKit

protocol NewTrackerViewControllerDelegate: AnyObject {
    func add(_ record: Tracker?)
}

final class NewTrackerViewController: UIViewController, TrackerTypeCellDelegate {
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
        textField.placeholder = "Введите название трекера"
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
        button.setTitle("Создать", for: .normal)
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
        button.setTitle("Отменить", for: .normal)
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
    
    private let emojis = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    
    private let colors = [
        "FD4C49", "FF881E", "007BFA", "6E44FE", "33CF69", "E66DD4",
        "F9D4D4", "34A7FE", "46E69D", "35347C", "FF674D", "FF99CC",
        "F6C48B", "7994F5", "832CF1", "AD56DA", "8D72E6", "2FD058"
    ]
    
    private var newTrackerName: String? {
        didSet {
            checkNewTrackerData()
        }
    }
    var newTrackerType: TrackerTypes? {
        didSet {
            checkNewTrackerData()
        }
    }
    private var newTrackerColor: String? {
        didSet {
            checkNewTrackerData()
        }
    }
    private var newTrackerEmoji: String? {
        didSet {
            checkNewTrackerData()
        }
    }
    var newTrackerCategory: String? {
        didSet {
            checkNewTrackerData()
        }
    }
    var newTrackerSchedule: [DaysOfWeek] = [] {
        didSet {
            checkNewTrackerData()
        }
    }

    private var trackerService = TrackerService.shared
    private var categoryRowsCount: Int = 0
    weak var delegate: NewTrackerViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNewTrackerViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let contentRect: CGRect = scrollView.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: contentRect.height)
    }
    
    private func checkNewTrackerData() {
        var allDataEntered = false
        if let newTrackerType, let newTrackerName, let _ = newTrackerEmoji, let _ = newTrackerColor, let _ = newTrackerCategory {
            allDataEntered = !(newTrackerName.isEmpty || (newTrackerType == .habit && newTrackerSchedule.isEmpty))
        }
        addButton.isEnabled = allDataEntered
        addButton.backgroundColor = allDataEntered ? UIColor.trackerBlack : UIColor.trackerGray
    }
    
    private func setupNewTrackerViewController() {
        view.backgroundColor = .trackerWhite
        if newTrackerType == .habit {
            titleLabel.text = "Новая привычка"
        } else {
            titleLabel.text = "Новое нерегулярное событие"
        }
        if let trackerType = newTrackerType {
            categoryRowsCount = trackerType == .irregularEvent ? 1 : 2
        }
        let indexPaths = (0..<categoryRowsCount).map { i in
            IndexPath(row: i, section: 0)
        }
        tableView.insertRows(at: indexPaths, with: .automatic)
        tableView.reloadData()
        addSubViews()
        applyConstraints()
    }
    
    private func addSubViews() {
        view.addSubviewWithoutAutoresizingMask(titleLabel)
        view.addSubviewWithoutAutoresizingMask(scrollView)
        scrollView.addSubviewWithoutAutoresizingMask(nameTextField)
        scrollView.addSubviewWithoutAutoresizingMask(tableView)
        scrollView.addSubviewWithoutAutoresizingMask(emojisCollectionView)
        scrollView.addSubviewWithoutAutoresizingMask(colorsCollectionView)
        scrollView.addSubviewWithoutAutoresizingMask(buttonsStackView)
        buttonsStackView.addArrangedSubview(cancelButton)
        buttonsStackView.addArrangedSubview(addButton)
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
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(categoryRowsCount * 75)),
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
    
    // MARK: - Actions
    
    @objc private func didTapAddButton() {
        let tracker = Tracker(name: newTrackerName ?? "",
                              trackerType: newTrackerType ?? .irregularEvent,
                              color: newTrackerColor ?? "7994F5",
                              emoji: newTrackerEmoji ?? "🤔",
                              schedule: newTrackerSchedule)
        delegate?.add(tracker)
    }
    
    @objc private func didTapCancelButton() {
        delegate?.add(nil)
    }
    
    @objc private func nameTextFieldDidChange(_ sender: UITextField) {
        newTrackerName = sender.text
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
}

// MARK: - UITableViewDataSource

extension NewTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryRowsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackerTypeCell.reuseIdentifier, for: indexPath)
        guard let cell = cell as? TrackerTypeCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.isSchedule = indexPath.row == 1
        if indexPath.row == categoryRowsCount - 1 {
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
                self.newTrackerCategory = category?.name
                self.tableView.reloadData()
            }
            self.present(categoryViewController, animated: true)
        } else {
            let scheduleViewController = ScheduleViewController()
            scheduleViewController.schedule = newTrackerSchedule
            scheduleViewController.dismissClosure = { schedule in
                self.newTrackerSchedule = schedule
                self.newTrackerSchedule.sort(by: {$0.dayNumber < $1.dayNumber})
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
            cell.emoji = emojis[indexPath.row]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.reuseIdentifier, for: indexPath)
            guard let cell = cell as? ColorCell else {
                return UICollectionViewCell()
            }
            cell.hexColor = colors[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackerHeaderView.reuseIdentifier, for: indexPath)
            guard let view = view as? TrackerHeaderView else {
                return UICollectionViewCell()
            }
            if collectionView == emojisCollectionView {
                view.title = "Emoji"
            } else {
                view.title = "Цвет"
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - UICollectionViewDelegate

extension NewTrackerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == emojisCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as? EmojiCell
            newTrackerEmoji = cell?.emoji
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as? ColorCell
            newTrackerColor = cell?.hexColor
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}

