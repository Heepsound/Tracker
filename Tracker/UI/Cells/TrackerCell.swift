//
//  TrackerCell.swift
//  Tracker
//
//  Created by Владимир Горбачев on 15.04.2024.
//

import UIKit

final class TrackerCell: UICollectionViewCell {
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .trackerWhite
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    private var emojiBackgroundLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.backgroundColor = .trackerWhiteAlpha30
        return label
    }()
    private var emojiLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        return label
    }()
    private var cardLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 16
        label.layer.masksToBounds = true
        label.textAlignment = .left
        return label
    }()
    private var counterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .trackerBlack
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    private lazy var completedButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("+", for: .normal)
        button.setTitleColor(.trackerWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 17
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapCompletedButton), for: .touchUpInside)
        return button
    }()
    
    var tracker: Tracker? {
        didSet {
            guard let tracker else { return }
            let color = UIColor(hex: tracker.color)
            titleLabel.text = tracker.name
            cardLabel.backgroundColor = color
            completedButton.backgroundColor = color
            emojiLabel.text = tracker.emoji
            if let indexPath {
                isDone = trackerRecordStore.isDone(indexPath: indexPath, trackersDate: trackerDate)
                doneTimes = trackerRecordStore.recordCount(indexPath: indexPath)
            }
            let canChangeStatus = trackerDate <= Calendar.current.startOfDay(for: Date())
            completedButton.isEnabled = canChangeStatus
            completedButton.alpha = canChangeStatus ? 1.0 : 0.3
        }
    }
    var indexPath: IndexPath?
    var trackerDate: Date = Date()
    
    private var doneTimes: Int = 0 {
        didSet {
            counterLabel.text = "\(doneTimes) дней"
        }
    }
    
    private var isDone: Bool = false {
        didSet {
            if isDone {
                completedButton.setImage(UIImage(named: "Done"), for: .normal)
                completedButton.setTitle("", for: .normal)
            } else {
                completedButton.setImage(UIImage(), for: .normal)
                completedButton.setTitle("+", for: .normal)
            }
        }
    }
    
    private var trackerRecordStore = TrackerRecordStore.shared
    static let reuseIdentifier = "trackerCell"
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTrackerCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTrackerCell() {
        addSubViews()
        applyConstraints()
    }
    
    private func addSubViews() {
        contentView.addSubviewWithoutAutoresizingMask(cardLabel)
        cardLabel.addSubviewWithoutAutoresizingMask(emojiBackgroundLabel)
        emojiBackgroundLabel.addSubviewWithoutAutoresizingMask(emojiLabel)
        cardLabel.addSubviewWithoutAutoresizingMask(titleLabel)
        contentView.addSubviewWithoutAutoresizingMask(counterLabel)
        contentView.addSubviewWithoutAutoresizingMask(completedButton)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            cardLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardLabel.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        NSLayoutConstraint.activate([
            emojiBackgroundLabel.leadingAnchor.constraint(equalTo: cardLabel.leadingAnchor, constant: 12),
            emojiBackgroundLabel.topAnchor.constraint(equalTo: cardLabel.topAnchor, constant: 12),
            emojiBackgroundLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiBackgroundLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: emojiBackgroundLabel.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiBackgroundLabel.centerYAnchor),
            emojiLabel.widthAnchor.constraint(equalToConstant: 22),
            emojiLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: cardLabel.leadingAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: cardLabel.bottomAnchor, constant: -12),
            titleLabel.trailingAnchor.constraint(equalTo: cardLabel.trailingAnchor, constant: -12)
        ])
        
        NSLayoutConstraint.activate([
            counterLabel.leadingAnchor.constraint(equalTo: cardLabel.leadingAnchor, constant: 12),
            counterLabel.topAnchor.constraint(equalTo: cardLabel.bottomAnchor, constant: 16),
            counterLabel.trailingAnchor.constraint(equalTo: cardLabel.trailingAnchor, constant: -12)
        ])
        
        NSLayoutConstraint.activate([
            completedButton.widthAnchor.constraint(equalToConstant: 34),
            completedButton.heightAnchor.constraint(equalToConstant: 34),
            completedButton.topAnchor.constraint(equalTo: cardLabel.bottomAnchor, constant: 8),
            completedButton.trailingAnchor.constraint(equalTo: cardLabel.trailingAnchor, constant: -12)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func didTapCompletedButton() {
        guard let indexPath, let id = tracker?.id else { return }
        if isDone {
            trackerRecordStore.delete(id: id, trackersDate: trackerDate)
        } else {
            trackerRecordStore.add(indexPath: indexPath, onDate: trackerDate )
        }
        isDone = !isDone
        doneTimes = trackerRecordStore.recordCount(indexPath: indexPath)
    }
}

