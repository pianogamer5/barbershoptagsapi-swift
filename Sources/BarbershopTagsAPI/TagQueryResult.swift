//
//  TagQueryResult.swift
//  
//
//  Created by Carson Greene on 1/29/22.
//

import Foundation
import XMLCoder

public struct TagQueryResult: Codable, DynamicNodeDecoding {
    public var tags = [Tag]()
    public var available: Int

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let availableString = try container.decode(String.self, forKey: .available)
        if let availableInt = Int(availableString) {
            available = availableInt
        } else {
            throw DecodingError.dataCorruptedError(forKey: .available, in: container, debugDescription: "Could not decode available integer")
        }
    }

    public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        return .attribute
    }
}
