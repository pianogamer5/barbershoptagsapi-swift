//
//  TagVideos.swift
//  
//
//  Created by Carson Greene on 1/29/22.
//

import Foundation
import XMLCoder

struct TagVideos: Codable, DynamicNodeDecoding {
    let videos: [TagVideo]
    let count: Int
    let available: Int

    static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        guard let videosKey = key as? TagVideos.CodingKeys else { return .elementOrAttribute }
        switch videosKey {
        case .videos:
            return .element
        case .count, .available:
            return.attribute
        }
    }

    enum CodingKeys: String, CodingKey {
        case videos = ""
        case count
        case available
    }
}
