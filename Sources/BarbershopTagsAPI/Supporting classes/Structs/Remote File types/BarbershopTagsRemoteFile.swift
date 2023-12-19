//
//  BarbershopTagsRemoteFile.swift
//  
//
//  Created by Carson Greene on 1/29/22.
//

import Foundation
import UniformTypeIdentifiers
import XMLCoder
import Combine

/// A structure describing a remote file belonging to a tag
public class BarbershopTagsRemoteFile: ObservableObject, Codable, DynamicNodeDecoding, Hashable {
    /// The URL to the remote file
    public var fileURL: URL?
    /// The format the file is in
    public var fileType: UTType?
    /// The blob of data at the file's URL, once fetched
    @Published public var dataBlob: Data?

    enum CodingKeys: String, CodingKey {
        case fileURL = ""
        case fileType = "type"
        case dataBlob
    }

    /// Create an empty BarbershopTagsRemoteFile, in case you need to
    public init() {
        // Don't init anything, just leave it nil
    }

    public init(dataBlob: Data, fileType: UTType) {
        self.dataBlob = dataBlob
        self.fileType = fileType
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let urlString = try container.decode(String.self, forKey: .fileURL)
        if let url = urlString.toURL() {
            fileURL = url
        } else {
            throw DecodingError.dataCorruptedError(forKey: BarbershopTagsRemoteFile.CodingKeys.fileURL, in: container, debugDescription: "Could not decode URL for remote file")
        }

        if let utTypeString = try? container.decode(String.self, forKey: .fileType),
           let utType = UTType(filenameExtension: utTypeString) {
            fileType = utType
        } else if let utType = try container.decodeIfPresent(UTType.self, forKey: .fileType) {
            fileType = utType
        }

        if let blob = try container.decodeIfPresent(Data.self, forKey: .dataBlob) {
            self.dataBlob = blob
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fileURL, forKey: .fileURL)
        try container.encode(fileType, forKey: .fileType)
        try container.encode(dataBlob, forKey: .dataBlob)
    }
    
    public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        guard let remoteFileKey = key as? BarbershopTagsRemoteFile.CodingKeys else { return .elementOrAttribute }
        switch remoteFileKey {
        case .fileURL:
            return .element
        case .fileType:
            return .attribute
        default:
            return .elementOrAttribute
        }
    }

    public func fetch() async throws {
        guard let url = fileURL else { return }
        let (data, response) = try await URLSession.shared.data(from: url)
        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode == 200 {
            DispatchQueue.main.async {
                self.dataBlob = data
            }
        } else {
            throw URLError(.badServerResponse)
        }
    }

    // MARK: - Hashable conformance
    public static func == (lhs: BarbershopTagsRemoteFile, rhs: BarbershopTagsRemoteFile) -> Bool {
        return (lhs.fileURL == rhs.fileURL) &&
            (lhs.fileType == rhs.fileType) &&
            (lhs.dataBlob == lhs.dataBlob)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(fileURL)
        hasher.combine(fileType)
        hasher.combine(dataBlob)
    }
}
