//
//  String.swift
//  CityDrive
//
//  Created by Иван Вдовин on 14.07.2023.
//

import Foundation

extension String {
    func ISO8601ToDate() -> Date? {
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        isoDateFormatter.formatOptions = [
            .withFullDate,
            .withFullTime,
            .withDashSeparatorInDate,
            .withFractionalSeconds]

        if let realDate = isoDateFormatter.date(from: self) {
            return realDate
        } else {
            return nil
        }
    }
}
