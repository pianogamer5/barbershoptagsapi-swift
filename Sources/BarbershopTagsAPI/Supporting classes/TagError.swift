//
//  TagError.swift
//  
//
//  Created by Carson Greene on 1/29/22.
//

import Foundation

/// Errors encountered when querying for tags
public enum TagError: Error {
    /// No tags were found for the query in the barbershoptags.com database
    case noTagsFound

    var localizedDescription: String {
        switch self {
        case .noTagsFound:
            return "No tags were found for the previous query"
        }
    }
}
