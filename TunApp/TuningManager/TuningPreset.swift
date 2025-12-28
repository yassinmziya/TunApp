//
//  TuningPreset.swift
//  TunApp
//
//  Created by Yassin Mziya on 12/22/25.
//

enum TuningPreset: Int, Identifiable {
    
    var id: String {
        return "\(rawValue)"
    }
    
    case guitarStandard = 0
    case guitarDropD
    case guitarOpenG
    
    var displayName: String {
        switch self {
        case .guitarStandard:
            return "Standard"
        case .guitarDropD:
            return "Drop D"
        case .guitarOpenG:
            return "Open G"
        }
    }
    
    var pitches: [Pitch] {
        switch self {
        case .guitarStandard:
            return [
                Pitch(pitchClass: .e, octave: 2),
                Pitch(pitchClass: .a, octave: 2),
                Pitch(pitchClass: .d, octave: 3),
                Pitch(pitchClass: .g, octave: 3),
                Pitch(pitchClass: .b, octave: 3),
                Pitch(pitchClass: .e, octave: 4)
            ]
        case .guitarDropD:
            return [
                Pitch(pitchClass: .d, octave: 2),
                Pitch(pitchClass: .a, octave: 2),
                Pitch(pitchClass: .d, octave: 3),
                Pitch(pitchClass: .g, octave: 3),
                Pitch(pitchClass: .b, octave: 3),
                Pitch(pitchClass: .e, octave: 4)
            ]
        case .guitarOpenG:
            return [
                Pitch(pitchClass: .d, octave: 2),
                Pitch(pitchClass: .g, octave: 2),
                Pitch(pitchClass: .d, octave: 3),
                Pitch(pitchClass: .g, octave: 3),
                Pitch(pitchClass: .b, octave: 3),
                Pitch(pitchClass: .d, octave: 4)
            ]
        }
    }
}
