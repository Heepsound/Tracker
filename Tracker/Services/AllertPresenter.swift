//
//  AllertPresenter.swift
//  Tracker
//
//  Created by Владимир Горбачев on 21.05.2024.
//

import UIKit

final class AlertPresenter {
    static func confirmDelete(title: String, delegate: UIViewController?, deleteCompletion: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .actionSheet)
        alert.addAction(
            UIAlertAction(
                title: NSLocalizedString("deleteButton.title", comment: "Заголовок действия удаления"),
                style: .destructive
            ) { _ in
                deleteCompletion()
            }
        )
        alert.addAction(
            UIAlertAction(
                title: NSLocalizedString("cancelButton.title", comment: "Заголовок действия отмены"),
                style: .cancel
            )
        )
        delegate?.present(alert, animated: true, completion: nil)
    }
}

