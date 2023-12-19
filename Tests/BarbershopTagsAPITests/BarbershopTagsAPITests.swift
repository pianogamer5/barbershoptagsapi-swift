import XCTest
@testable import BarbershopTagsAPI

final class BarbershopTagsAPITests: XCTestCase {
    func testGetByID() async {
        do {
            let pantsFeet = try await BarbershopTagsAPI.getTagByID(5345)
            print(pantsFeet)

            XCTAssertEqual(pantsFeet.id, 5345)
            XCTAssertEqual(pantsFeet.title, "PantsFeet")
        } catch let DecodingError.dataCorrupted(context) {
            XCTFail(context.debugDescription)
        } catch let DecodingError.keyNotFound(key, context) {
            XCTFail("Key '\(key)' not found:")
            XCTFail(context.debugDescription)
            XCTFail("codingPath: \(context.codingPath)")
        } catch let DecodingError.valueNotFound(value, context) {
            XCTFail("Value '\(value)' not found:")
            XCTFail(context.debugDescription)
            XCTFail("codingPath: \(context.codingPath)")
        } catch let DecodingError.typeMismatch(type, context)  {
            XCTFail("Type '\(type)' mismatch:")
            XCTFail(context.debugDescription)
            XCTFail("codingPath: \(context.codingPath)")
        } catch {
            print(error)
            XCTFail(error.localizedDescription)
        }
    }

    func testTagSerialization() {
        do {
            let mockTag = MockTag()
            let tagData = try JSONEncoder().encode(mockTag)
            let decodedTag = try JSONDecoder().decode(Tag.self, from: tagData)
            XCTAssertEqual(decodedTag.id, mockTag.id)
            XCTAssertEqual(decodedTag.title, mockTag.title)
            XCTAssertEqual(decodedTag.altTitle, mockTag.altTitle)
            XCTAssertEqual(decodedTag.version, mockTag.version)
            XCTAssertEqual(decodedTag.key, mockTag.key)
            XCTAssertEqual(decodedTag.parts, mockTag.parts)
            XCTAssertEqual(decodedTag.voicingType, mockTag.voicingType)
            XCTAssertEqual(decodedTag.recordingMethod, mockTag.recordingMethod)
            XCTAssertEqual(decodedTag.learningVideoYouTubeID, mockTag.learningVideoYouTubeID)
            XCTAssertEqual(decodedTag.notes, mockTag.notes)
            XCTAssertEqual(decodedTag.arranger, mockTag.arranger)
            XCTAssertEqual(decodedTag.arrangerWebsite, mockTag.arrangerWebsite)
            XCTAssertEqual(decodedTag.sungBy, mockTag.sungBy)
            XCTAssertEqual(decodedTag.sungWebsite, mockTag.sungWebsite)
            XCTAssertEqual(decodedTag.sungYear, mockTag.sungYear)
            XCTAssertEqual(decodedTag.learningTrackArtist, mockTag.learningTrackArtist)
            XCTAssertEqual(decodedTag.learningTrackArtistWebsite, mockTag.learningTrackArtistWebsite)
            XCTAssertEqual(decodedTag.teacher, mockTag.teacher)
            XCTAssertEqual(decodedTag.teacherWebsite, mockTag.teacherWebsite)
            XCTAssertEqual(decodedTag.provider, mockTag.provider)
            XCTAssertEqual(decodedTag.providerWebsite, mockTag.providerWebsite)
            XCTAssertEqual(decodedTag.posted, mockTag.posted)
            XCTAssertEqual(decodedTag.classicIndex, mockTag.classicIndex)
            XCTAssertEqual(decodedTag.collection, mockTag.collection)
            XCTAssertEqual(decodedTag.rating, mockTag.rating)
            XCTAssertEqual(decodedTag.ratingCount, mockTag.ratingCount)
            XCTAssertEqual(decodedTag.downloaded, mockTag.downloaded)
            XCTAssertEqual(decodedTag.sheetMusic, mockTag.sheetMusic)
            XCTAssertEqual(decodedTag.notationFile, mockTag.notationFile)
            XCTAssertEqual(decodedTag.allPartsTrack, mockTag.allPartsTrack)
            XCTAssertEqual(decodedTag.lyrics, mockTag.lyrics)
            XCTAssertEqual(decodedTag.tenorLearningTrack, mockTag.tenorLearningTrack)
            XCTAssertEqual(decodedTag.leadLearningTrack, mockTag.leadLearningTrack)
            XCTAssertEqual(decodedTag.bariLearningTrack, mockTag.bariLearningTrack)
            XCTAssertEqual(decodedTag.bassLearningTrack, mockTag.bassLearningTrack)
            XCTAssertEqual(decodedTag.other1LearningTrack, mockTag.other1LearningTrack)
            XCTAssertEqual(decodedTag.other2LearningTrack, mockTag.other2LearningTrack)
            XCTAssertEqual(decodedTag.other3LearningTrack, mockTag.other3LearningTrack)
            XCTAssertEqual(decodedTag.other4LearningTrack, mockTag.other4LearningTrack)
            XCTAssertEqual(decodedTag.videos, mockTag.videos)
        } catch let DecodingError.dataCorrupted(context) {
            XCTFail(context.debugDescription)
        } catch let DecodingError.keyNotFound(key, context) {
            XCTFail("Key '\(key)' not found:")
            XCTFail(context.debugDescription)
            XCTFail("codingPath: \(context.codingPath)")
        } catch let DecodingError.valueNotFound(value, context) {
            XCTFail("Value '\(value)' not found:")
            XCTFail(context.debugDescription)
            XCTFail("codingPath: \(context.codingPath)")
        } catch let DecodingError.typeMismatch(type, context)  {
            XCTFail("Type '\(type)' mismatch:")
            XCTFail(context.debugDescription)
            XCTFail("codingPath: \(context.codingPath)")
        } catch {
            print(error)
            XCTFail(error.localizedDescription)
        }
    }
}
// MARK: - Query tests
final class BarbershopTagsAPIQueryTests: XCTestCase {
    func testQueryString() async throws {
        let tags = try await BarbershopTagsAPI.getTagsWithQuery("smile", fldList: [.id])
        XCTAssertTrue(!tags.tags.isEmpty)
    }

    func testQueryNumTags() async throws {
        let tagsResult = try await BarbershopTagsAPI.getTagsWithQuery(numTags: 15, fldList: [.id])
        XCTAssertEqual(15, tagsResult.tags.count)
    }

    func testQueryNumParts() async throws {
        let tagsResult = try await BarbershopTagsAPI.getTagsWithQuery(numParts: 8, fldList: [.parts])
        XCTAssertTrue(tagsResult.tags.filter({ $0.parts != 8 }).isEmpty)
    }

    func testQueryVoicingTypes() async throws {
        for type in TagVoicingType.allCases {
            let tagsResult = try await BarbershopTagsAPI.getTagsWithQuery(voicingTypes: [type], fldList: [.voicingType])
            XCTAssertTrue(tagsResult.tags.filter({ $0.voicingType != type }).isEmpty)
        }
    }

    func testQueryLearningTracks() async throws {
        let tagsResult = try await BarbershopTagsAPI.getTagsWithQuery(hasLearningTracks: true, fldList: Tag.CodingKeys.learningTracks)
        XCTAssertTrue(tagsResult.tags.filter({ $0.learningTracks.isEmpty }).isEmpty)
    }

    func testQuerySheetMusic() async throws {
        let tagsResult = try await BarbershopTagsAPI.getTagsWithQuery(hasSheetMusic: false, fldList: [.sheetMusic])
        XCTAssertTrue(tagsResult.tags.filter({ $0.sheetMusic != nil }).isEmpty)
    }

    func testQueryCollection() async throws {
        for collection in TagCollectionType.allCases {
            let tagsResult = try await BarbershopTagsAPI.getTagsWithQuery(collection: collection, fldList: [.collection])
            XCTAssertTrue(tagsResult.tags.filter({ $0.collection != collection }).isEmpty)
        }
    }

    func testQueryMinRating() async throws {
        let tagsResult = try await BarbershopTagsAPI.getTagsWithQuery(minRating: 3.0, sort: .byRating, fldList: [.rating])
        XCTAssertTrue(tagsResult.tags.filter({ $0.rating < 3.0 }).isEmpty)
    }

    func testQueryMinDownloads() async throws {
        let tagsResult = try await BarbershopTagsAPI.getTagsWithQuery(minDownloaded: 10000, sort: .byDownloaded, fldList: [.downloaded])
        XCTAssertTrue(tagsResult.tags.filter({ $0.downloaded < 10000 }).isEmpty)
    }

    func testQueryMinStamp() async throws {
        let tagsResult = try await BarbershopTagsAPI.getTagsWithQuery(minStamp: Date.past24Hrs, sort: .byStamp, fldList: [.stamp])
        XCTAssertTrue(tagsResult.tags.filter({ $0.stamp < Date.past24Hrs }).isEmpty)
    }

    func testQuerySortBy() async throws {
        for sortOrder in TagQuerySortingOrder.allCases {
            let tagsResult = try await BarbershopTagsAPI.getTagsWithQuery(collection: sortOrder == .byClassicIndex ? .classic : nil,
                                                                          sort: sortOrder)
            var sortedArray: [Tag]
            switch sortOrder {
            case .byTitle:
                print("testing title sort")
                sortedArray = tagsResult.tags.sorted(by: { $0.title < $1.title })
            case .byPosted:
                print("testing posted date sort")
                sortedArray = tagsResult.tags.sorted(by: { $0.posted > $1.posted })
            case .byStamp:
                print("testing update stamp sort")
                sortedArray = tagsResult.tags.sorted(by: { $0.stamp > $1.stamp })
            case .byRating:
                print("testing rating sort")
                sortedArray = tagsResult.tags.sorted(by: { $0.rating > $1.rating })
            case .byDownloaded:
                print("testing download count sort")
                sortedArray = tagsResult.tags.sorted(by: { $0.downloaded > $1.downloaded })
            case .byClassicIndex:
                print("testing classic index sort")
                sortedArray = tagsResult.tags.sorted(by: {
                    guard let classicIndex1 = $0.classicIndex,
                          let classicIndex2 = $1.classicIndex else { return false }
                    return classicIndex1 < classicIndex2
                })
            }
            XCTAssertEqual(sortedArray, tagsResult.tags)
        }
    }
}

// MARK: - Regression tests
final class BarbershopTagsAPIRegressionTest: XCTestCase {
    func testAllTags() async {
        do {
            var tagsAvailable = 0
            var tagsTested = 0
            let tagResult = try await BarbershopTagsAPI.getTagsWithQuery()
            tagsAvailable = tagResult.available
            tagsTested = tagResult.tags.count
            while tagsTested < tagsAvailable {
                print("Tested \(tagsTested) of \(tagsAvailable) tags")
                let tagResult = try await BarbershopTagsAPI.getTagsWithQuery(startIndex: tagsTested)
                tagsTested += tagResult.tags.count
            }
            print("Testing complete!")
        } catch let DecodingError.dataCorrupted(context) {
            XCTFail(context.debugDescription)
        } catch let DecodingError.keyNotFound(key, context) {
            XCTFail("Key '\(key)' not found:")
            XCTFail(context.debugDescription)
            XCTFail("codingPath: \(context.codingPath)")
        } catch let DecodingError.valueNotFound(value, context) {
            XCTFail("Value '\(value)' not found:")
            XCTFail(context.debugDescription)
            XCTFail("codingPath: \(context.codingPath)")
        } catch let DecodingError.typeMismatch(type, context)  {
            XCTFail("Type '\(type)' mismatch:")
            XCTFail(context.debugDescription)
            XCTFail("codingPath: \(context.codingPath)")
        } catch {
            print(error)
            XCTFail(error.localizedDescription)
        }
    }

    // !!WARNING!! Please try to not test this that much.
    // There are no serverside checks to prevent multiple ratings,
    // so running this many times will skew the ratings.
    // Only run if changes were made to BarbershopTagsAPI.rate.
    func testRating() async throws {
        try await BarbershopTagsAPI.rate(tagID: 5345, rating: 5)
    }
}
