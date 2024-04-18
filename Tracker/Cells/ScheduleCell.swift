//
//  SheduleCell.swift
//  Tracker
//
//  Created by Владимир Горбачев on 14.04.2024.
//

import UIKit

final class ScheduleCell: UITableViewCell {
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .trackerBlack
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    private lazy var scheduleSwitch: UISwitch = {
        let scheduleSwitch = UISwitch()
        scheduleSwitch.onTintColor = .trackerBlue
        scheduleSwitch.addTarget(self, action: #selector(valueChangedScheduleSwitch), for: .valueChanged)
        return scheduleSwitch
    }()
    
    var dayOfWeek: DaysOfWeek? {
        didSet {
            if let dayOfWeek {
                titleLabel.text = dayOfWeek.name
                if let _ = trackerService.newTrackerSchedule.firstIndex(of: dayOfWeek) {
                    scheduleSwitch.isOn = true
                }
            } else {
                titleLabel.text = "Неопределено"
            }
        }
    }
    
    private var trackerService = TrackerService.shared
    
    static let reuseIdentifier = "scheduleCell"
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupScheduleCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupScheduleCell() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        addSubViews()
        applyConstraints()
    }
    
    private func addSubViews() {
        self.addSubviewWithoutAutoresizingMask(titleLabel)
        self.addSubviewWithoutAutoresizingMask(scheduleSwitch)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: scheduleSwitch.leadingAnchor)
        ])
        NSLayoutConstraint.activate([
            scheduleSwitch.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            scheduleSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func valueChangedScheduleSwitch(_ sender: UISwitch) {
        guard let dayOfWeek else { return }
        if sender.isOn {
            trackerService.newTrackerSchedule.append(dayOfWeek)
        } else {
            if let index = trackerService.newTrackerSchedule.firstIndex(of: dayOfWeek) {
                trackerService.newTrackerSchedule.remove(at: index)
            }
        }
    }
}
