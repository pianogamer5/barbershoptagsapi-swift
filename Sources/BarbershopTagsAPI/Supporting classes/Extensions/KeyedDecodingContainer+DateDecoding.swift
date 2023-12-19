//
//  KeyedDecodingContainer+StringFallbackDecoding.swift
//  
//
//  Created by Carson Greene on 2/2/22.
//

import Foundation

extension KeyedDecodingContainer {
    func decodeDateOrDateStringIfPresent(forKey key: KeyedDecodingContainer.Key, formatString: String) throws -> Date? {
        if let date = try? self.decodeIfPresent(Date.self, forKey: key) {
            return date
        } else if let dateString = try self.decodeNonEmptyStringIfPresent(forKey: key) {
            return dateString.toDate(formatString: formatString)
        }
        return nil
    }

    func decodeURLOrURLStringIfPresent(forKey key: KeyedDecodingContainer.Key) throws -> URL? {
        if let url = try? self.decodeIfPresent(URL.self, forKey: key) {
            return url
        } else if let urlString = try self.decodeNonEmptyStringIfPresent(forKey: key) {
            return urlString.toURL()
        }
        return nil
    }
}
