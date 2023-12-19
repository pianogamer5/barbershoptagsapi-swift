//
//  TagCollectionType.swift
//  
//
//  Created by Carson Greene on 1/29/22.
//

import Foundation

/// What collction a tag belongs to
public enum TagCollectionType: String, CaseIterable, Codable, Hashable, Identifiable {
    public var id: String {
        rawValue
    }
    
    /// No collection
    case none = ""
    /// David Wright's "Classic Tags"
    case classic
    /// The "Easy Tags" collection
    case easyTags = "easytags"
    /// The "100 Days: 100 Tags" collection
    case oneHundred = "100"

    /// A human readable title for each collection
    public var prettyString: String {
        switch self {
        case .classic:
            return "Classic Tags"
        case .easyTags:
            return "Easy Tags"
        case .oneHundred:
            return "100 Days: 100 Tags"
        case .none:
            return ""
        }
    }
}
