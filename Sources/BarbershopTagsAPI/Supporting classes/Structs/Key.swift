//
//  Key.swift
//  
//
//  Created by Carson Greene on 1/29/22.
//

/// A structure describing the key a tag is written in
public struct Key: Codable, Hashable {
    /// The tonic note
    public var note: Note
    /// The tonality of the key
    public var tonality: Tonality

    public init(note: Note, tonality: Tonality) {
        self.note = note
        self.tonality = tonality
    }

    public init(keyString: String) throws {
        let keyStringComponents = keyString.components(separatedBy: ":")
        if keyStringComponents.count == 2,
           let note = Note(rawValue: keyStringComponents[1]),
           let tonality = Tonality(rawValue: keyStringComponents[0]) {
            self.note = note
            self.tonality = tonality
        } else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Could not decode Key \(keyString)"))
        }
    }

    public var description: String {
        "\(note.prettyString) \(tonality.rawValue)"
    }
}

/// All possible notes a key can be
public enum Note: String, CaseIterable, Codable, Hashable {
    case cFlat = "Cb"
    case c = "C"
    case cSharp = "C#"
    case dFlat = "Db"
    case d = "D"
    case dSharp = "D#"
    case eFlat = "Eb"
    case e = "E"
    case eSharp = "E#"
    case fFlat = "Fb"
    case f = "F"
    case fSharp = "F#"
    case gFlat = "Gb"
    case g = "G"
    case gSharp = "G#"
    case aFlat = "Ab"
    case a = "A"
    case aSharp = "A#"
    case bFlat = "Bb"
    case b = "B"
    case bSharp = "B#"

    /// A string meant for display to users. Uses unicode characters for sharps and flats.
    public var prettyString: String {
        rawValue
            .replacingOccurrences(of: "b", with: "♭")
            .replacingOccurrences(of: "#", with: "♯")
    }
}

/// All possible tonalities a key can be
public enum Tonality: String, CaseIterable, Codable, Hashable {
    case major = "Major"
    case minor = "Minor"
    case dorian = "Dorian"
    case phrygian = "Phrygian"
    case lydian = "Lydian"
    case mixolydian = "Mixolydian"
    case aeolian = "Aeolian"
    case locrian = "Locrian"
}
