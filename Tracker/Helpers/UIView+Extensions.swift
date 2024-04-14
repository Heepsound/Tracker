//
//  UIView+Extensions.swift
//  Tracker
//
//  Created by Владимир Горбачев on 06.04.2024.
//

import UIKit

extension UIView {
    func addSubviewWithoutAutoresizingMask(_ subView: UIView) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(subView)
    }
}
