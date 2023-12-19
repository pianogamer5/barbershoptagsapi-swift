//
//  LearningTrackRecordingMethod.swift
//  
//
//  Created by Carson Greene on 1/29/22.
//

import Foundation

/// How learning tracks for a tag were recorded
public enum LearningTrackRecordingMethod: String, CaseIterable, Codable, Hashable {
    /// No recording
    case none = ""
    /// The featured part recorded in one channel, the other parts recorded in another
    case stereo = "stereo - one part on one side, the other parts on the other side"
    /// The featured part is louder, the other parts are quieter
    case partPredominant = "part predominant - one part louder, other parts quieter"
    /// The featured part is the only part in the track
    case singlePart = "single part only"
}
