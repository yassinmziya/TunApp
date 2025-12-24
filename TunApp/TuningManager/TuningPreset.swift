//
//  TuningPreset.swift
//  TunApp
//
//  Created by Yassin Mziya on 12/22/25.
//

enum TuningPreset: String, Identifiable {
    
    var id: String {
        return rawValue
    }
    
    case standard = "Standard"
    case dropD = "Drop D"
    case openG = "Open G"
    
    var pitches: [Pitch] {
        switch self {
        case .standard:
            return [
                Pitch(pitchClass: .e, octave: 2),
                Pitch(pitchClass: .a, octave: 2),
                Pitch(pitchClass: .d, octave: 3),
                Pitch(pitchClass: .g, octave: 3),
                Pitch(pitchClass: .b, octave: 3),
                Pitch(pitchClass: .e, octave: 4)
            ]
        case .dropD:
            return [
                Pitch(pitchClass: .d, octave: 2),
                Pitch(pitchClass: .a, octave: 2),
                Pitch(pitchClass: .d, octave: 3),
                Pitch(pitchClass: .g, octave: 3),
                Pitch(pitchClass: .b, octave: 3),
                Pitch(pitchClass: .e, octave: 4)
            ]
        case .openG:
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
