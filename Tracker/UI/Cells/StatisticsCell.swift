//
//  StatisticsCell.swift
//  Tracker
//
//  Created by Владимир Горбачев on 29.05.2024.
//

import UIKit

final class StatisticsCell: UITableViewCell {
    private var countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .trackerText
        label.font = UIFont.boldSystemFont(ofSize: 34)
        return label
    }()
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .trackerText
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    private var backLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        return label
    }()
    
    var trackersStatistics: TrackersStatistics? {
        didSet {
            guard let trackersStatistics else { return }
            countLabel.text = String(trackersStatistics.count)
            titleLabel.text = trackersStatistics.name
        }
    }
    
    static let reuseIdentifier = "statisticsCell"
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let gradientColors = [
            UIColor.init(hex: "007BFA") ?? .red,
            UIColor.init(hex: "46E69D") ?? .green,
            UIColor.init(hex: "FD4C49") ?? .blue
        ]
        let gradient = UIImage.gradientImage(bounds: self.bounds, colors: gradientColors)
        backLabel.layer.borderColor = UIColor(patternImage: gradient).cgColor
        backLabel.layer.borderWidth = 1
        backLabel.layer.cornerRadius = 16
    }
    
    private func setupCell() {
        backgroundColor = .clear
        selectionStyle = .none
        addSubViews()
        applyConstraints()
    }
    
    private func addSubViews() {
        [backLabel, countLabel, titleLabel].forEach { subview in
            self.addSubviewWithoutAutoresizingMask(subview)
        }
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            backLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 6),
            backLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6)
        ])
        NSLayoutConstraint.activate([
            countLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            countLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            countLabel.topAnchor.constraint(equalTo: backLabel.topAnchor, constant: 12)
        ])
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: backLabel.bottomAnchor, constant: -12)
        ])
    }
}
