//
//  MockTag.swift
//  
//
//  Created by Carson Greene on 2/1/22.
//

import Foundation

public class MockTag: Tag {
    private let fourTwentySixtyNine = Date(timeIntervalSince1970: 3133657200)
    private let rickAstley = "Rick Astley"
    private let rickAstleySite = URL(string: "https://www.rickastley.co.uk/")
    public override init() {
        super.init()
        id = 42069
        title = "Never Gonna Give You Up"
        altTitle = "Rick Roll"
        version = "Funny Meme version"
        if let key = try? Key(keyString: "Major:Bb") {
            self.key = key
        }
        parts = 4
        voicingType = .barbershop
        recordingMethod = .stereo
        learningVideoYouTubeID = "YE7VzlLtp-4"
        notes = """
                This is that funny meme song.
                You know the one, when you click something expecting it to be one thing, but it turns out to be just this song?
                It's pretty great. This is a tag based on that song (not really, this is just mock data!)
                If you're reading this, you're probably a developer working on a new barbershoptags.com app.
                If that's you, then cheers!
                If not, then either the developer made a mistake, or maybe they put this in as some kind of easter egg...
                Anyways, I'm really just making this so long for testing views.
                Okay I'll shut up now 😊
                """
        arranger = rickAstley
        arrangerWebsite = rickAstleySite
        sungBy = rickAstley
        sungWebsite = rickAstleySite
        sungYear = fourTwentySixtyNine
        learningTrackArtist = rickAstley
        learningTrackArtistWebsite = rickAstleySite
        teacher = rickAstley
        teacherWebsite = rickAstleySite
        provider = rickAstley
        providerWebsite = rickAstleySite
        posted = fourTwentySixtyNine
        classicIndex = 420
        collection = .classic
        rating = 4.2
        ratingCount = 690
        downloaded = 4200
        stamp = fourTwentySixtyNine
//        sheetMusic: BarbershopTagsRemoteFile?
//        notationFile: BarbershopTagsRemoteFile?
//        allPartsTrack: BarbershopTagsRemoteFile?
        lyrics = """
                Never gonna give you up,
                Never gonna let you down,
                Never gonna run around
                and desert you
                """
//        tenorLearningTrack: BarbershopTagsRemoteFile?
//        leadLearningTrack: BarbershopTagsRemoteFile?
//        bariLearningTrack: BarbershopTagsRemoteFile?
//        bassLearningTrack: BarbershopTagsRemoteFile?
//        other1LearningTrack: BarbershopTagsRemoteFile?
//        other2LearningTrack: BarbershopTagsRemoteFile?
//        other3LearningTrack: BarbershopTagsRemoteFile?
//        other4LearningTrack: BarbershopTagsRemoteFile?
//        videos = [Video()]
    }

    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}
