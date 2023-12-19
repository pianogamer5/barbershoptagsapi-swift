//
//  Tag.swift
//  
//
//  Created by Carson Greene on 1/29/22.
//

import Foundation
/// Data structure describing a barbershop tag returned from barbershoptags.com
open class Tag: Identifiable, Codable, Hashable {
    // MARK: - Non-optional properties
    /// The ID of the tag in the barbershoptags.com database
    public var id: Int
    /// The Title of the tag
    public var title: String
    /// The type of arrangement the tag is
    public var voicingType: TagVoicingType
    /// The date the tag was posted to barbershoptags.com
    public var posted: Date
    /// The average 5-star rating as a decimal
    public var rating: Double
    /// The number of people that have rated this tag
    public var ratingCount: Int
    /// How many times the tag has been downloaded
    public var downloaded: Int
    /// The date the tag was last updated
    public var stamp: Date

    // MARK: - Optional properties
    /// An alternate title for the tag
    public var altTitle: String?
    /// The version of the tag (i.e. as performed by)
    public var version: String?
    /// The key the tag is written in
    public var key: Key?
    /// The number of parts a tag is written for. If "other" is returned from the API, this will be assigned `Int.max`
    public var parts: Int?
    /// The method by which the learning tracks were recorded (e.g. stereo, prominent, etc.)
    public var recordingMethod: LearningTrackRecordingMethod?
    // barbershoptags.com does not store the YouTube link itself, only the video ID. Not really relevant to client apps though, so we build the actual YouTube url below using this to store the ID
    var learningVideoYouTubeID: String?
    /// A YouTube link to the learning video
    public var learningVideoURL: URL? {
        if let youTubeID = learningVideoYouTubeID {
            return URL(string: "https://youtube.com/watch?v=\(youTubeID)")
        }
        return nil
    }
    /// Any notes or comments made by the tag's uploader
    public var notes: String?
    /// The name of the tag's arranger
    public var arranger: String?
    /// The arranger's website
    public var arrangerWebsite: URL?
    /// The artist that made the tag famous
    public var sungBy: String?
    /// The website of the artist thta made the tag famous
    public var sungWebsite: URL?
    /// The year the tag was made famous
    public var sungYear: Date?
    /// The quartet or person that sung the learning tracks
    public var learningTrackArtist: String?
    /// The website of the quartet or person that sung the learning tracks
    public var learningTrackArtistWebsite: URL?
    /// The teacher that produced the learning track video
    public var teacher: String?
    /// The website of the teacher that produced the learning track video
    public var teacherWebsite: URL?
    /// The person that provided the tag or learning tracks
    public var provider: String?
    /// The website of the person that provided the tag or learning tracks
    public var providerWebsite: URL?
    /// If the tag is part of David Wright's "Classic Tags" booklet, this is the tag number within that booklet
    public var classicIndex: Int?
    /// Which collection, if any, the tag belongs to
    public var collection: TagCollectionType?
    /// The tag's sheet music
    public var sheetMusic: BarbershopTagsRemoteFile?
    /// The tag's music notation file
    public var notationFile: BarbershopTagsRemoteFile?
    /// The recording of all parts being sung, untampered with
    public var allPartsTrack: BarbershopTagsRemoteFile?
    /// The lyrics to the tag
    public var lyrics: String?
    /// The tenor learning track
    public var tenorLearningTrack: BarbershopTagsRemoteFile?
    /// The lead learning track
    public var leadLearningTrack: BarbershopTagsRemoteFile?
    /// The bari learning track
    public var bariLearningTrack: BarbershopTagsRemoteFile?
    /// The bass learning track
    public var bassLearningTrack: BarbershopTagsRemoteFile?
    /// The first other learning track
    public var other1LearningTrack: BarbershopTagsRemoteFile?
    /// The second other learning track
    public var other2LearningTrack: BarbershopTagsRemoteFile?
    /// The third other learning track
    public var other3LearningTrack: BarbershopTagsRemoteFile?
    /// The fourth other learning track
    public var other4LearningTrack: BarbershopTagsRemoteFile?
    /// An array of all available learning tracks, coded by `Tag.CodingKeys`
    public var learningTracks: [Tag.CodingKeys: BarbershopTagsRemoteFile] {
        var tracks = [Tag.CodingKeys: BarbershopTagsRemoteFile]()
        if let allParts = allPartsTrack  {
            tracks[.allPartsTrack] = allParts
        }
        if let tenorTrack = tenorLearningTrack {
            tracks[.tenorLearningTrack] = tenorTrack
        }
        if let leadTrack = leadLearningTrack {
            tracks[.leadLearningTrack] = leadTrack
        }
        if let bariTrack = bariLearningTrack {
            tracks[.bariLearningTrack] = bariTrack
        }
        if let bassTrack = bassLearningTrack {
            tracks[.bassLearningTrack] = bassTrack
        }
        if let other1Track = other1LearningTrack {
            tracks[.other1LearningTrack] = other1Track
        }
        if let other2Track = other2LearningTrack {
            tracks[.other2LearningTrack] = other2Track
        }
        if let other3Track = other3LearningTrack {
            tracks[.other3LearningTrack] = other3Track
        }
        if let other4Track = other4LearningTrack {
            tracks[.other4LearningTrack] = other4Track
        }
        return tracks
    }
    /// Videos of the tag being performed
    public var videos: [TagVideo]?

    /// A private initializer to get an empty object. Used by MockTag (though could be useful elsewhere)
    ///
    /// You should generally *avoid* using this method, unless you know you need an empty tag object that will be replaced later. All this does is provide initial values for the non-optional properties, they're not real data of any kind.
    public init() {
        // Initialize what we have to, rest is up to consumer
        id = -1
        title = ""
        voicingType = .barbershop
        posted = .distantPast
        rating = -1
        ratingCount = -1
        downloaded = -1
        stamp = .distantPast
    }

    // MARK: - Decoder init
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Decode non-optional properties
        if let id = try container.decodeIfPresent(Int.self, forKey: .id) {
            self.id = id
        } else {
            id = -1
        }
        
        if let title = try container.decodeNonEmptyStringIfPresent(forKey: .title) {
            self.title = title
        } else {
            title = ""
        }

        if let voicingType = try container.decodeIfPresent(TagVoicingType.self, forKey: .voicingType) {
            self.voicingType = voicingType
        } else {
            voicingType = .barbershop
        }

        if let posted = try container.decodeDateOrDateStringIfPresent(forKey: .posted, formatString: "EEE, d MMM yyyy") {
            self.posted = posted
        } else {
            posted = .distantPast
        }

        if let ratingDouble = try? container.decodeIfPresent(Double.self, forKey: .rating) {
            rating = ratingDouble
        } else {
            rating = 0
        }

        if let ratingCountInt = try? container.decodeIfPresent(Int.self, forKey: .ratingCount) {
            ratingCount = ratingCountInt
        } else {
            ratingCount = 0
        }

        if let downloaded = try? container.decodeIfPresent(Int.self, forKey: .downloaded) {
            self.downloaded = downloaded
        } else {
            downloaded = 0
        }

        if let stamp = try container.decodeDateOrDateStringIfPresent(forKey: .stamp, formatString: "yyyy-MM-dd HH:mm:ss") {
            self.stamp = stamp
        } else {
            stamp = .distantPast
        }

        // Decode optional properties
        altTitle = try container.decodeNonEmptyStringIfPresent(forKey: .altTitle)
        version = try container.decodeNonEmptyStringIfPresent(forKey: .version)

        if let writKey = try? container.decodeIfPresent(Key.self, forKey: .key) {
            key = writKey
        } else if let keyString = try container.decodeNonEmptyStringIfPresent(forKey: .key) {
            key = try Key(keyString: keyString)
        }

        if let numParts = try? container.decodeIfPresent(Int.self, forKey: .parts) {
            parts = numParts
        } else if let numParts = try container.decodeIfPresent(String.self, forKey: .parts),
                  numParts == "other" {
            parts = .max
        }
        
        recordingMethod = try container.decodeIfPresent(LearningTrackRecordingMethod.self, forKey: .recordingMethod)
        learningVideoYouTubeID = try container.decodeNonEmptyStringIfPresent(forKey: .learningVideoYouTubeID)
        notes = try container.decodeNonEmptyStringIfPresent(forKey: .notes)
        arranger = try container.decodeNonEmptyStringIfPresent(forKey: .arranger)
        arrangerWebsite = try container.decodeURLOrURLStringIfPresent(forKey: .arrangerWebsite)
        sungBy = try container.decodeNonEmptyStringIfPresent(forKey: .sungBy)
        sungWebsite = try container.decodeURLOrURLStringIfPresent(forKey: .sungWebsite)
        sungYear = try container.decodeDateOrDateStringIfPresent(forKey: .sungYear, formatString: "yyyy")
        learningTrackArtist = try container.decodeNonEmptyStringIfPresent(forKey: .learningTrackArtist)
        learningTrackArtistWebsite = try container.decodeURLOrURLStringIfPresent(forKey: .learningTrackArtistWebsite)
        teacher = try container.decodeNonEmptyStringIfPresent(forKey: .teacher)
        teacherWebsite = try container.decodeURLOrURLStringIfPresent(forKey: .teacherWebsite)
        provider = try container.decodeNonEmptyStringIfPresent(forKey: .provider)
        providerWebsite = try container.decodeURLOrURLStringIfPresent(forKey: .providerWebsite)

        if let classicInt = try? container.decodeIfPresent(Int.self, forKey: .classicIndex) {
            classicIndex = classicInt
        } else if let classicString = try container.decodeNonEmptyStringIfPresent(forKey: .classicIndex) {
            classicIndex = Int(classicString)
        }

        collection = try container.decodeIfPresent(TagCollectionType.self, forKey: .collection)
        sheetMusic = try? container.decodeIfPresent(BarbershopTagsRemoteFile.self, forKey: .sheetMusic)
        notationFile = try? container.decodeIfPresent(BarbershopTagsRemoteFile.self, forKey: .notationFile)
        allPartsTrack = try? container.decodeIfPresent(BarbershopTagsRemoteFile.self, forKey: .allPartsTrack)
        lyrics = try container.decodeNonEmptyStringIfPresent(forKey: .lyrics)
        tenorLearningTrack = try? container.decodeIfPresent(BarbershopTagsRemoteFile.self, forKey: .tenorLearningTrack)
        leadLearningTrack = try? container.decodeIfPresent(BarbershopTagsRemoteFile.self, forKey: .leadLearningTrack)
        bariLearningTrack = try? container.decodeIfPresent(BarbershopTagsRemoteFile.self, forKey: .bariLearningTrack)
        bassLearningTrack = try? container.decodeIfPresent(BarbershopTagsRemoteFile.self, forKey: .bassLearningTrack)
        other1LearningTrack = try? container.decodeIfPresent(BarbershopTagsRemoteFile.self, forKey: .other1LearningTrack)
        other2LearningTrack = try? container.decodeIfPresent(BarbershopTagsRemoteFile.self, forKey: .other2LearningTrack)
        other3LearningTrack = try? container.decodeIfPresent(BarbershopTagsRemoteFile.self, forKey: .other3LearningTrack)
        other4LearningTrack = try? container.decodeIfPresent(BarbershopTagsRemoteFile.self, forKey: .other4LearningTrack) 
//        if let videosContainer = try container.decodeIfPresent(TagVideos.self, forKey: .videos) {
//            videos = videosContainer.videos
//        }
    }

    // MARK: - Hashable conformance
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
    }

    public static func == (lhs: Tag, rhs: Tag) -> Bool {
        lhs.id == rhs.id
    }

    // MARK: - Codable keys
    /// The coding keys for Tag. Used to decode the raw XML data returned from barbershoptags.com, but also used to control what fields get returned from queries
    public enum CodingKeys: String, CaseIterable, CodingKey, Identifiable {
        public var id: String {
            rawValue
        }

        /// The ID of the tag in the barbershoptags.com database
        case id
        /// The title of the tag
        case title
        /// An alternate title for the tag
        case altTitle
        /// The version of the tag (i.e. as performed by)
        case version
        /// The key the tag is written in
        case key = "writKey"
        /// The number of parts a tag is written for
        case parts
        /// What kind of group the tag was arranged for
        case voicingType = "type"
        /// How the learning tracks were recorded (e.g. stereo, prominent, etc.)
        case recordingMethod = "recording"
        /// The YouTube video id of the teaching video (required to use `Tag.youTubeVideoURL`
        case learningVideoYouTubeID = "teachVid"
        /// Any notes or comments made by the tag's uploader
        case notes
        /// The name of the tag's arranger
        case arranger
        /// The arranger's website
        case arrangerWebsite = "arrWebsite"
        /// The artist that made the tag famous
        case sungBy
        /// The website of the artist thta made the tag famous
        case sungWebsite
        /// The year the tag was made famous
        case sungYear
        /// The quartet or person that sung the learning tracks
        case learningTrackArtist = "quartet"
        /// The website of the quartet or person that sung the learning tracks
        case learningTrackArtistWebsite = "qWebsite"
        /// The teacher that produced the learning track video
        case teacher
        /// The website of the teacher that produced the learning track video
        case teacherWebsite = "tWebsite"
        /// The person that provided the tag or learning tracks
        case provider
        /// The website of the person that provided the tag or learning tracks
        case providerWebsite = "provWebsite"
        /// The date the tag was posted to barbershoptags.com
        case posted
        /// If the tag is part of David Wright's "Classic Tags" booklet, this is the tag number within that booklet
        case classicIndex = "classic"
        /// Which collection, if any, the tag belongs to
        case collection
        /// The average 5-star rating as a decimal
        case rating
        /// The number of people that have rated this tag
        case ratingCount
        /// How many times the tag has been downloaded
        case downloaded
        /// The date the tag was last updated
        case stamp
        /// The tag's sheet music
        case sheetMusic
        /// The tag's music notation file
        case notationFile = "notation"
        /// The recording of all parts being sung, untampered with
        case allPartsTrack = "allParts"
        /// The lyrics to the tag
        case lyrics
        /// The tenor learning track
        case tenorLearningTrack = "tenor"
        /// The lead learning track
        case leadLearningTrack = "lead"
        /// The bari learning track
        case bariLearningTrack = "bari"
        /// The bass learning track
        case bassLearningTrack = "bass"
        /// The first other learning track
        case other1LearningTrack = "other1"
        /// The second other learning track
        case other2LearningTrack = "other2"
        /// The third other learning track
        case other3LearningTrack = "other3"
        /// The fourth other learning track
        case other4LearningTrack = "other4"
        /// Videos of the tag being performed
        case videos

        public static var learningTracks: [CodingKeys] = [
            .allPartsTrack,
            .tenorLearningTrack,
            .leadLearningTrack,
            .bariLearningTrack,
            .bassLearningTrack,
            .other1LearningTrack,
            .other2LearningTrack,
            .other3LearningTrack,
            .other4LearningTrack
        ]
    }
}
