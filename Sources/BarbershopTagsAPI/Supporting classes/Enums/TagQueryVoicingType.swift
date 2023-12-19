//
//  QueryVoicingType.swift
//  
//
//  Created by Carson Greene on 2/1/22.
//

import Foundation

/// What voices a tag is written for (used when searching with `BarbershopTagsAPI.getQuery()`)
public enum TagQueryVoicingType: String, CaseIterable, Codable, Hashable {
    /// Traditional male barbershop arrangement (tenor, lead, bari, bass)
    case barbershop = "bbs"
    /// Traditional female barbershop arrangement (tenor, lead, bari, bass)
    case sweetAdelines = "sai"
    /// Traditional mixed choir arrangement (soprano, alto, tenor, bass)
    case satb
    /// Other kinds of male arrangements
    case otherMale = "male"
    /// Other kinds of female arrangements
    case otherFemale = "female"
    /// Other kinds of mixed arrangements
    case mixed
}
