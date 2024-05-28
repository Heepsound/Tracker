//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Владимир Горбачев on 06.04.2024.
//

import UIKit

final class StatisticsViewController: UIViewController {
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("tabBar.statistics.title" , comment: "Заголовок формы статистики")
        label.textColor = .trackerBlack
        label.font = UIFont.boldSystemFont(ofSize: 34)
        return label
    }()
    private var workAreaStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    private var noStatisticsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "StatisticsError")
        return imageView
    }()
    private var noStatisticsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .trackerBlack
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = NSLocalizedString("statistics.noStatisticsLabel", comment: "Текст при отсутствии статистики")
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    private func setupViewController() {
        view.backgroundColor = .trackerBackground
        addSubViews()
        applyConstraints()
    }
    
    private func addSubViews() {
        [titleLabel, workAreaStackView].forEach { subview in
            view.addSubviewWithoutAutoresizingMask(subview)
        }
        [noStatisticsImageView, noStatisticsLabel].forEach { subview in
            workAreaStackView.addSubviewWithoutAutoresizingMask(subview)
        }
    }

    private func applyConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 41),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        NSLayoutConstraint.activate([
            workAreaStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            workAreaStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            workAreaStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            workAreaStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            noStatisticsImageView.heightAnchor.constraint(equalToConstant: 80),
            noStatisticsImageView.widthAnchor.constraint(equalToConstant: 80),
            noStatisticsImageView.centerXAnchor.constraint(equalTo: workAreaStackView.centerXAnchor),
            noStatisticsImageView.centerYAnchor.constraint(equalTo: workAreaStackView.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            noStatisticsLabel.heightAnchor.constraint(equalToConstant: 18),
            noStatisticsLabel.centerXAnchor.constraint(equalTo: workAreaStackView.centerXAnchor),
            noStatisticsLabel.topAnchor.constraint(equalTo: noStatisticsImageView.bottomAnchor, constant: 8)
        ])
    }
}
