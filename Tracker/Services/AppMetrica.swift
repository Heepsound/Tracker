//
//  AppMetrica.swift
//  Tracker
//
//  Created by Владимир Горбачев on 29.05.2024.
//

import Foundation
import YandexMobileMetrica

enum AppMetricaEvents: String {
    case open = "open"
    case close = "close"
    case click = "click"
}

final class AppMetrica {
   
    static func sendEvent(event: AppMetricaEvents, screen: String, item: String) {
        let params : [AnyHashable : Any] = ["event": event.rawValue, "screen": screen, "item": item]
        YMMYandexMetrica.reportEvent("EVENT", parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
