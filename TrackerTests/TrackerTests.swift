//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Владимир Горбачев on 28.05.2024.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    func testTrackersViewController() {
        let vc = TrackersViewController(nibName: nil, bundle: nil)
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
        //assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
}
