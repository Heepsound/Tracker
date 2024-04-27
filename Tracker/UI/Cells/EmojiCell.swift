//
//  EmojiCell.swift
//  Tracker
//
//  Created by Владимир Горбачев on 18.04.2024.
//

import UIKit

final class EmojiCell: UICollectionViewCell {
    private var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.backgroundColor = .clear
        label.layer.cornerRadius = 16
        label.layer.masksToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    var emoji: String? {
        didSet {
            guard let emoji else { return }
            emojiLabel.text = emoji
        }
    }
    
    override var isSelected: Bool {
        didSet {
            super.isSelected = isSelected
            emojiLabel.backgroundColor = isSelected ? UIColor.trackerLightGray : UIColor.clear
        }
    }

    static let reuseIdentifier = "emojiCell"
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupEmogiCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupEmogiCell() {
        addSubViews()
        applyConstraints()
    }
    
    private func addSubViews() {
        contentView.addSubviewWithoutAutoresizingMask(emojiLabel)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emojiLabel.widthAnchor.constraint(equalToConstant: 52),
            emojiLabel.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
}
