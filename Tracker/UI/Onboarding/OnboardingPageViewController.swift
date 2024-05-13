//
//  OnboardingPageViewController.swift
//  Tracker
//
//  Created by Владимир Горбачев on 11.05.2024.
//

import UIKit

final class OnboardingPageViewController: UIViewController {
    private var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        return imageView
    }()
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .trackerBlack
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private lazy var confirmButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .trackerBlack
        button.setTitle("Вот это технологии!", for: .normal)
        button.setTitleColor(.trackerWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapСonfirmButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    convenience init(backgroundImage: UIImage, title: String) {
        self.init()
        self.backgroundImageView.image = backgroundImage
        self.titleLabel.text = title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    func setupViewController() {
        addSubViews()
        applyConstraints()
    }
    
    private func addSubViews() {
        [backgroundImageView, titleLabel, confirmButton].forEach { subview in
            view.addSubviewWithoutAutoresizingMask(subview)
        }
    }

    private func applyConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            confirmButton.widthAnchor.constraint(equalToConstant: 335),
            confirmButton.heightAnchor.constraint(equalToConstant: 60),
            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -160)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func didTapСonfirmButton() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        UserDefaultsService.onboardingCompleted = true
        window.rootViewController = TabBarController()
        window.makeKeyAndVisible()
    }
}
