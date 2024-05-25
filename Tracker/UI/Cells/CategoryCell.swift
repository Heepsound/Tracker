//
//  CategoryCell.swift
//  Tracker
//
//  Created by Владимир Горбачев on 15.04.2024.
//

import UIKit

final class CategoryCell: UITableViewCell {
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .trackerBlack
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    private var markImageView: UIImageView = {
        let imageView = UIImageView(image: .mark)
        imageView.isHidden = true
        return imageView
    }()
    
    var categoryName: String? {
        didSet {
            if let categoryName {
                titleLabel.text = categoryName
            } else {
                titleLabel.text = NSLocalizedString("undefined", comment: "Значение неопределено")
            }
        }
    }
    
    var isMarked: Bool? {
        didSet {
            if let isMarked {
                markImageView.isHidden = !isMarked
            } else {
                markImageView.isHidden = true
            }
        }
    }
    
    static let reuseIdentifier = "categoryCell"
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCategoryCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCategoryCell() {
        backgroundColor = .trackerFieldAlpha30
        selectionStyle = .none
        addSubViews()
        applyConstraints()
    }
    
    private func addSubViews() {
        [titleLabel, markImageView].forEach { subview in
            self.addSubviewWithoutAutoresizingMask(subview)
        }
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: markImageView.leadingAnchor, constant: -16)
        ])
        NSLayoutConstraint.activate([
            markImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            markImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            markImageView.widthAnchor.constraint(equalToConstant: 24),
            markImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
