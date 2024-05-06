//
//  TrackerType.swift
//  Tracker
//
//  Created by Владимир Горбачев on 14.04.2024.
//

import UIKit

protocol TrackerTypeCellDelegate: AnyObject {
    var newTrackerSchedule: [DaysOfWeek] { get }
    var newTrackerCategory: String? { get }
}

final class TrackerTypeCell: UITableViewCell {
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .trackerBlack
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    private var valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .trackerGray
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    private var workAreaStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 0
        return stackView
    }()
    private var buttonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Select")
        return imageView
    }()
    
    var isSchedule: Bool? {
        didSet {
            if let isSchedule {
                if isSchedule {
                    titleLabel.text = "Расписание"
                    valueLabel.text = ""
                    guard let schedule = delegate?.newTrackerSchedule else { return }
                    if schedule.count == 7 {
                        valueLabel.text = "Каждый день"
                    } else {
                        for dayOfWeek in schedule {
                            if let isEmpty = valueLabel.text?.isEmpty, !isEmpty {
                                valueLabel.text?.append(", ")
                            }
                            valueLabel.text?.append(dayOfWeek.shortName)
                        }
                    }
                } else {
                    titleLabel.text = "Категория"
                    valueLabel.text = delegate?.newTrackerCategory ?? ""
                }
            } else {
                titleLabel.text = "Неопределено"
                valueLabel.text = ""
            }
        }
    }
    
    weak var delegate: TrackerTypeCellDelegate?
    
    static let reuseIdentifier = "trackerTypeCell"
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCategoryCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCategoryCell() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        addSubViews()
        applyConstraints()
    }
    
    private func addSubViews() {
        self.addSubviewWithoutAutoresizingMask(buttonImageView)
        self.addSubviewWithoutAutoresizingMask(workAreaStackView)
        workAreaStackView.addArrangedSubview(titleLabel)
        workAreaStackView.addArrangedSubview(valueLabel)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            workAreaStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            workAreaStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            workAreaStackView.trailingAnchor.constraint(equalTo: buttonImageView.leadingAnchor)
        ])
        NSLayoutConstraint.activate([
            buttonImageView.widthAnchor.constraint(equalToConstant: 24),
            buttonImageView.heightAnchor.constraint(equalToConstant: 24),
            buttonImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            buttonImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}


