//
//  String+TypeConversion.swift
//  
//
//  Created by Carson Greene on 1/29/22.
//

import Foundation

extension String {
    public func toURL() -> URL? {
        URL(string: self)
    }

    public func toDate(formatString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatString
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: self) {
            return date
        }
        return nil
    }
}
