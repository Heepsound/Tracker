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
        tabBar.backgroundColor = .trackerBackground
        tabBar.tintColor = .trackerBlue

        let trackersViewController = TrackersViewController()
        let trackersNavigationController = UINavigationController(rootViewController: trackersViewController)
        trackersNavigationController.modalPresentationStyle = .overCurrentContext
        
        let tabTrackersTitle = NSLocalizedString("tabBar.trackers.title", comment: "Заголовок вкладки с трекерами")
        trackersNavigationController.tabBarItem = UITabBarItem(title: tabTrackersTitle, image: UIImage(named: "TabTrackers"), selectedImage: nil)
        
        let tabStatisticsTitle = NSLocalizedString("tabBar.statistics.title", comment: "Заголовок вкладки со статистикой")
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.tabBarItem = UITabBarItem(title: tabStatisticsTitle, image: UIImage(named: "TabStatistics"), selectedImage: nil)
        
        self.viewControllers = [trackersNavigationController, statisticsViewController]
    }
}

