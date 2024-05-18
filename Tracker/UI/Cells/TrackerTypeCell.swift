//
//  TrackerType.swift
//  Tracker
//
//  Created by Владимир Горбачев on 14.04.2024.
//

import UIKit

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
                    titleLabel.text = NSLocalizedString("schedule", comment: "Заголовок расписание")
                    valueLabel.text = ""
                    guard let schedule = viewModel?.trackerSchedule else { return }
                    if schedule.count == 7 {
                        valueLabel.text = NSLocalizedString("trackerTypeCell.schedule.everyDay", comment: "Заголовок при выборе всех дней в расписаниии")
                    } else {
                        for dayOfWeek in schedule {
                            if let isEmpty = valueLabel.text?.isEmpty, !isEmpty {
                                valueLabel.text?.append(", ")
                            }
                            valueLabel.text?.append(dayOfWeek.shortName)
                        }
                    }
                } else {
                    titleLabel.text = NSLocalizedString("category", comment: "Заголовок категория")
                    valueLabel.text = viewModel?.trackerCategory?.name ?? ""
                }
            } else {
                titleLabel.text = NSLocalizedString("undefined", comment: "Значение неопределено")
                valueLabel.text = ""
            }
        }
    }
    
    var viewModel: NewTrackerViewModel?
    
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
        [buttonImageView, workAreaStackView].forEach { subview in
            self.addSubviewWithoutAutoresizingMask(subview)
        }
        [titleLabel, valueLabel].forEach { subview in
            workAreaStackView.addArrangedSubview(subview)
        }
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


