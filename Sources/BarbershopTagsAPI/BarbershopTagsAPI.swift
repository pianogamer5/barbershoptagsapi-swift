import Foundation
import XMLCoder

public struct BarbershopTagsAPI {
    static private let baseURL = URLComponents(string: "https://barbershoptags.com/api.php")
    static private var clientQueryItem: URLQueryItem? {
        if let appName =  Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String {
            return URLQueryItem(name: "client", value: String(appName))
        }
        return nil
    }

    /// Fetch a single tag from barbershoptags.com
    ///
    /// - Parameter id: The ID of the tag from barbershoptags.com
    /// - Returns: The Tag object if found
    /// - Throws:`TagError.noTagsFound` if the given tag ID does not exist in the database
    public static func getTagByID(_ id: Int) async throws -> Tag {
        // Get the base request URL, throw if something went wrong doing that
        guard var requestComponents = baseURL else { throw URLError(.badURL) }
        // Add the id parameter, the only one we need for this query
        requestComponents.queryItems = [
            URLQueryItem(name: "id", value: String(id))
        ]
        // Add the client query item, if it exists
        if let queryItem = clientQueryItem {
            requestComponents.queryItems?.append(queryItem)
        }
        // Make sure the URL we just built is valid, otherwise throw
        guard let requestURL = requestComponents.url else { throw URLError(.badURL) }
        // Perform the request
        let (data, response) = try await URLSession.shared.data(from: requestURL)
        // Check to see if the response we get back is HTTP and that the status code is good
        // (if it ain't, we got issues...)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badServerResponse) }
        // Set up the XML decoder
        let decoder = XMLDecoder()
        decoder.keyDecodingStrategy = .convertFromCapitalized
        // Try to decode the tags array
        let tags = try decoder.decode([Tag].self, from: data)
        // Get the individual tag from the array, or error out
        if let tag = tags.first {
            return tag
        }
        else {
            throw TagError.noTagsFound
        }
    }

    /// Send a query to the barbershoptags.com API
    /// - Parameter query: A query string
    /// - Parameter numTags: The number of tags to fetch
    /// - Parameter startIndex: What index to start fetching at (zero-indexed)
    /// - Parameter numParts: The number of parts the returned tags will contain
    /// - Parameter voicingTypes: Which kind of groups the returned tags were arranged for
    /// - Parameter hasLearningTracks: Whether or not the returned tags have learning tracks
    /// - Parameter hasSheetMusic: Whether or not the returned tags have sheet music
    /// - Parameter collection: What `CollctionType` the returned tags belong to
    /// - Parameter minRating: The minimum rating the returned tags have
    /// - Parameter minDownloaded: The minimum number of downloads the returned tags have
    /// - Parameter minStamp: The minimum timestamp the returned tags have
    /// - Parameter sortBy: The order in which the tags will be sorted (see `TagQuerySortingOrder` for all the options)
    /// - Parameter fldList: The fields that will be fetched (defaults to all fields)
    /// - Returns: A `Tags` object with an array of returned tags and the total number of tags available
    public static func getTagsWithQuery(_ searchQuery: String? = nil,
                                        numTags: Int? = 10,
                                        startIndex: Int? = 0,
                                        numParts: Int? = nil,
                                        voicingTypes: Set<TagVoicingType>? = nil,
                                        hasLearningTracks: Bool? = nil,
                                        hasSheetMusic: Bool? = nil,
                                        collection: TagCollectionType? = nil,
                                        minRating: Double? = nil,
                                        minDownloaded: Double? = nil,
                                        minStamp: Date? = nil,
                                        sort: TagQuerySortingOrder? = nil,
                                        fldList: [Tag.CodingKeys?]? = nil) async throws -> TagQueryResult {
        // Get the base request URL, throw if something went wrong doing that
        guard var requestComponents = baseURL else { throw URLError(.badURL) }
        var queryItems = [URLQueryItem]()
        // Add the query parameters if they exist
        if let n = numTags {
            queryItems.append(URLQueryItem(name: "n", value: String(n)))
        }
        if let start = startIndex {
            queryItems.append(URLQueryItem(name: "start", value: String(start + 1)))
        }
        if let query = searchQuery {
            queryItems.append(URLQueryItem(name: "q", value: query))
        }
        if let parts = numParts {
            queryItems.append(URLQueryItem(name: "Parts", value: String(parts)))
        }
        if let types = voicingTypes,
           var typeString = types.first?.queryString {
            for type in types.dropFirst() {
                typeString += "|\(type.queryString)"
            }
            queryItems.append(URLQueryItem(name: "Type", value: typeString))
        }
        if let learningTracks = hasLearningTracks {
            queryItems.append(URLQueryItem(name: "Learning", value: learningTracks ? "Yes" : "No"))
        }
        if let sheetMusic = hasSheetMusic {
            queryItems.append(URLQueryItem(name: "SheetMusic", value: sheetMusic ? "Yes" : "No"))
        }
        if let collection = collection {
            queryItems.append(URLQueryItem(name: "Collection", value: collection.rawValue))
        }
        if let minRating = minRating {
            queryItems.append(URLQueryItem(name: "MinRating", value: String(minRating)))
        }
        if let minDownloaded = minDownloaded {
            queryItems.append(URLQueryItem(name: "MinDownloaded", value: String(minDownloaded)))
        }
        if let minStamp = minStamp {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            queryItems.append(URLQueryItem(name: "Minstamp", value: dateFormatter.string(from: minStamp)))
        }
        if let order = sort {
            queryItems.append(URLQueryItem(name: "Sortby", value: order.rawValue))
        }
        if let fldList = fldList,
           var fldListString = fldList.first??.rawValue {
            for fld in fldList.dropFirst() {
                if let fld = fld {
                    fldListString += ",\(fld)"
                }
            }
            queryItems.append(URLQueryItem(name: "fldlist", value: fldListString))
        }
        // Add the client query item, if it exists
        if let queryItem = clientQueryItem {
            queryItems.append(queryItem)
        }
        requestComponents.queryItems = queryItems
        // Make sure the URL we just built is valid, otherwise throw
        guard let requestURL = requestComponents.url else { throw URLError(.badURL) }
        // Perform the request
        let (data, response) = try await URLSession.shared.data(from: requestURL)
        // Check to see if the response we get back is HTTP and that the status code is good
        // (if it ain't, we got issues...)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badServerResponse) }
        // Set up the XML decoder
        let decoder = XMLDecoder()
        decoder.keyDecodingStrategy = .convertFromCapitalized
        // Try to decode the tags info object
        var tags = try decoder.decode(TagQueryResult.self, from: data)
        if tags.available == 0 {
            // If there's nothing available, return the tags not found error
            throw TagError.noTagsFound
        } else {
            // Decode the array of tags
            tags.tags = try decoder.decode([Tag].self, from: data)
            return tags
        }
    }

    /// Rates a tag on barbershoptags.com
    /// - Parameter tagID: The ID of the tag to rate
    /// - Parameter rating: An integer between 1 and 5 (inclusive)
    public static func rate(tagID: Int, rating: Int) async throws {
        // Get the base request URL, throw if something went wrong doing that
        guard var requestComponents = baseURL else { throw URLError(.badURL) }
        requestComponents.queryItems = [
            URLQueryItem(name: "action", value: "rate"),
            URLQueryItem(name: "id", value: String(tagID)),
            URLQueryItem(name: "rating", value: String(rating))
        ]

        // Make sure the URL we just built is valid, otherwise throw
        guard let requestURL = requestComponents.url else { throw URLError(.badURL) }
        // Perform the request
        let (data, response) = try await URLSession.shared.data(from: requestURL)
        // Check to see if the response we get back is HTTP and that the status code is good
        // (if it ain't, we got issues...)
        guard (response as? HTTPURLResponse)?.statusCode == 200,
              let responseString = String(data: data, encoding: .utf8),
              responseString == "ok"
        else { throw URLError(.badServerResponse) }
    }
}
