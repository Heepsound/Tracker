//
//  MainViewController.swift
//  Tracker
//
//  Created by Владимир Горбачев on 06.04.2024.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    private func setupTabBar() {
        tabBar.barStyle = .default
        tabBar.backgroundColor = .trackerWhite
        tabBar.tintColor = .trackerBlue

        let trackersViewController = TrackersViewController()
        let trackersNavigationController = UINavigationController(rootViewController: trackersViewController)
        trackersNavigationController.modalPresentationStyle = .overCurrentContext
        trackersNavigationController.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(named: "TabTrackers"), selectedImage: nil)
        
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(named: "TabStatistics"), selectedImage: nil)
        
        self.viewControllers = [trackersNavigationController, statisticsViewController]
    }
}

