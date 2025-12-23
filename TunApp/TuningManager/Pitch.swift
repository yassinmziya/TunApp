//
//  Pitch.swift
//  TunApp
//
//  Created by Yassin Mziya on 12/22/25.
//

import Foundation

struct Pitch: Identifiable, Equatable {
    
    let pitchClass: PitchClass
    let octave: Int
    
    var id: String {
        return "\(pitchClass.name())\(octave)"
    }
    
    func frequency(referenceA4: Float = 440.0) -> Float {
        // Calculate semitones from A4
        // A4 is PitchClass.a (9) at octave 4
        let semitonesFromA = Float((octave - 4) * 12 + (pitchClass.rawValue - PitchClass.a.rawValue))
        return referenceA4 * powf(2.0, semitonesFromA / 12.0)
    }
    
    static var referenceRange: [Pitch] {
        return [
            Pitch(pitchClass: .a, octave: 0),
            Pitch(pitchClass: .aSharp, octave: 0),
            Pitch(pitchClass: .b, octave: 0),
            Pitch(pitchClass: .c, octave: 0),
            Pitch(pitchClass: .cSharp, octave: 0),
            Pitch(pitchClass: .d, octave: 0),
            Pitch(pitchClass: .dSharp, octave: 0),
            Pitch(pitchClass: .e, octave: 0),
            Pitch(pitchClass: .f, octave: 0),
            Pitch(pitchClass: .fSharp, octave: 0),
            Pitch(pitchClass: .g, octave: 0),
            Pitch(pitchClass: .gSharp, octave: 0),
        ]
    }
}
