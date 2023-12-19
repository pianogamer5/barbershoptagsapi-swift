//
//  KeyedDecodingContainer.swift
//  
//
//  Created by Carson Greene on 1/30/22.
//

import Foundation

extension KeyedDecodingContainer {
    func decodeNonEmptyStringIfPresent(forKey key: KeyedDecodingContainer.Key) throws -> String? {
        if let string = try self.decodeIfPresent(String.self, forKey: key), !string.isEmpty {
            return string
        }
        return nil
    }
}
