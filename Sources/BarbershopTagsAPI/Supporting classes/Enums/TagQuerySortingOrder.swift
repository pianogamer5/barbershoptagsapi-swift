//
//  TagQuerySortingOrder.swift
//  
//
//  Created by Carson Greene on 1/29/22.
//

/// Control how returned tags are sorted
public enum TagQuerySortingOrder: String, CaseIterable, Identifiable {
    /// A copy of `rawValue`, for conformance to `Identifiable`
    public var id: String {
        rawValue
    }

    /// Sort by the title of the tag
    case byTitle = "Title"
    /// Sort by original post date (descending)
    case byPosted = "Posted"
    /// Sort by the timestamp of when the tag was last updated
    case byStamp = "stamp"
    /// Sort by the total ratings of the tag (descending)
    case byRating = "Rating"
    /// Sort by how many downloads a tag has
    case byDownloaded = "Downloaded"
    /// Sort by the index in David Wright's Classic Tag Book
    /// **NOTE:** this should *only* be used in conjunction with `TagCollctionType.classic` when performing API calls,
    /// using without that parameter could cause unexpected behavior
    case byClassicIndex = "Classic"

    /// A human-readable string in title case describing the sorting order. Useful for displaying sort options
    public var prettyString: String {
        switch self {
        case .byTitle:
            return "Title"
        case .byPosted:
            return "Post Date"
        case .byStamp:
            return "Updated"
        case .byRating:
            return "Rating"
        case .byDownloaded:
            return "Downloads"
        case .byClassicIndex:
            return "Classic Tag Book Order"
        }
    }
}
