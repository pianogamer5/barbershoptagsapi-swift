//
//  Date+today.swift
//  
//
//  Created by Carson Greene on 2/2/22.
//

import Foundation

extension Date {
    static var today: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMddyyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let dateString = dateFormatter.string(from: now)
        return dateFormatter.date(from: dateString)!
    }

    static var past24Hrs: Date {
        return Date(timeIntervalSinceNow: -86400)
    }
}
