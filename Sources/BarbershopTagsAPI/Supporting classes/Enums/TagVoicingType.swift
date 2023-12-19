//
//  VoicingType.swift
//  
//
//  Created by Carson Greene on 1/29/22.
//

/// What voices a tag is written for (used by the property in the Tag object)
public enum TagVoicingType: String, CaseIterable, Codable, Identifiable, Hashable {
    public var id: String {
        rawValue
    }

    /// Traditional male barbershop arrangement (tenor, lead, bari, bass)
    case barbershop = "Barbershop"
    /// Traditional female barbershop arrangement (tenor, lead, bari, bass)
    case sweetAdelines = "Female Barbershop (incl. SAI, HI, etc)"
    /// Traditional mixed choir arrangement (soprano, alto, tenor, bass)
    case satb = "SATB"
    /// Other kinds of male arrangements
    case otherMale = "Other male"
    /// Other kinds of female arrangements
    case otherFemale = "Other female"
    /// Other kinds of mixed arrangements
    case mixed = "Other mixed"

    var queryString: String {
        switch self {
        case .barbershop:
            return "bbs"
        case .sweetAdelines:
            return "sai"
        case .satb:
            return "satb"
        case .otherMale:
            return "male"
        case .otherFemale:
            return "female"
        case .mixed:
            return "mixed"
        }
    }
}

