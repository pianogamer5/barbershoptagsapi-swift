//
//  Video.swift
//  
//
//  Created by Carson Greene on 1/29/22.
//

import Foundation

/// A struct representing a video on barbershoptags.com
public struct TagVideo: Identifiable, Codable, Hashable {
    /// The video's unique ID
    public var id: Int
    /// The video's description
    public var description: String?
    /// The key the video was sung in
    public var sungKey: Key?
    /// Whether or not the video is a multitrack (i.e. all parts were recorded in a single take)
    public var multitrack: Bool
    /// The YouTube ID of the video
    var youtubeID: String?
    /// The Facebook URL of the video
    var facebookURL: URL?
    /// The  URL of the video
    public var videoURL: URL? {
        if let videoID = youtubeID {
            return URL(string: "https://youtube.com/watch?v=\(videoID)")
        }
        else if facebookURL != nil {
            return facebookURL
        }
        return nil
    }
    /// Name of the singer or quartet in the video
    public var author: String?
    /// Website of the singer or quartet in the video
    public var authorWebsite: URL?
    /// The date the video was added to barbershoptags.com
    public var posted: Date

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        if let postedDate = try container.decode(String.self, forKey: .posted).toDate(formatString: "E, d MMM YYYY") {
            posted = postedDate
        } else {
            throw DecodingError.dataCorruptedError(forKey: TagVideo.CodingKeys.posted, in: container, debugDescription: "Could not decode video posted date")
        }

        description = try container.decodeNonEmptyStringIfPresent(forKey: .description)
        if let sungKeyString = try container.decodeNonEmptyStringIfPresent(forKey: .sungKey) {
            sungKey = try Key(keyString: sungKeyString)
        }
        if let multitrackString = try container.decodeNonEmptyStringIfPresent(forKey: .multitrack) {
            multitrack = multitrackString == "Yes"
        } else {
            multitrack = false
        }
        youtubeID = try container.decodeNonEmptyStringIfPresent(forKey: .youtubeID)
        facebookURL = try container.decodeNonEmptyStringIfPresent(forKey: .facebookURL)?.toURL()
        author = try container.decodeNonEmptyStringIfPresent(forKey: .author)
        authorWebsite = try container.decodeNonEmptyStringIfPresent(forKey: .authorWebsite)?.toURL()
    }

    // MARK: - Codable keys
    enum CodingKeys: String, CodingKey {
        case id
        case description = "Desc"
        case sungKey
        case multitrack
        case youtubeID = "Code"
        case facebookURL = "Facebook"
        case author = "SungBy"
        case authorWebsite = "SungWebsite"
        case posted
    }
}
