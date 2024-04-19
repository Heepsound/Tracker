//
//  ColorCell.swift
//  Tracker
//
//  Created by Владимир Горбачев on 18.04.2024.
//

import UIKit

final class ColorCell: UICollectionViewCell {
    private var colorLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        return label
    }()
    private var selectedLabel: UILabel = {
        let label = UILabel()
        label.layer.borderColor = UIColor.clear.cgColor
        label.layer.borderWidth = 3
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        return label
    }()
    
    var hexColor: String? {
        didSet {
            guard let hexColor else { return }
            colorLabel.backgroundColor = UIColor(hex: hexColor)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            super.isSelected = isSelected
            guard let hexColor else { return }
            selectedLabel.layer.borderColor = isSelected ? UIColor(hex: hexColor)?.cgColor.copy(alpha: 0.3) : UIColor.clear.cgColor
        }
    }

    static let reuseIdentifier = "colorCell"
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupColorCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupColorCell() {
        addSubViews()
        applyConstraints()
    }
    
    private func addSubViews() {
        contentView.addSubviewWithoutAutoresizingMask(selectedLabel)
        contentView.addSubviewWithoutAutoresizingMask(colorLabel)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            selectedLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            selectedLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            selectedLabel.widthAnchor.constraint(equalToConstant: 52),
            selectedLabel.heightAnchor.constraint(equalToConstant: 52)
        ])
        NSLayoutConstraint.activate([
            colorLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorLabel.widthAnchor.constraint(equalToConstant: 40),
            colorLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
