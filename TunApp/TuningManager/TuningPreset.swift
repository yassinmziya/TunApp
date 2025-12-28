//
//  TuningPreset.swift
//  TunApp
//
//  Created by Yassin Mziya on 12/22/25.
//

enum TuningPreset: Int, Identifiable, CaseIterable {
    
    var id: String {
        return "\(rawValue)"
    }
    
    // MARK: - Standard & Step-Down Variations
    case guitarStandard = 0
    case guitarHalfStepDown
    case guitarWholeStepDown  // D Standard
    case guitarCStandard
    
    // MARK: - Drop Tunings
    case guitarDropD
    case guitarDropCSharp
    case guitarDropC
    case guitarDropB
    case guitarDropA
    
    // MARK: - Alternate & Open Tunings
    case guitarDADGAD
    case guitarOpenG
    case guitarOpenD
    case guitarOpenE
    case guitarDoubleDropD
    
    // MARK: - Specialist & Modern Tunings
    case guitarNashville
    case guitarNewStandard  // Fripp
    case guitarRainSong
    
    var displayName: String {
        switch self {
        case .guitarStandard:
            return "Standard"
        case .guitarHalfStepDown:
            return "Half Step Down"
        case .guitarWholeStepDown:
            return "D Standard"
        case .guitarCStandard:
            return "C Standard"
        case .guitarDropD:
            return "Drop D"
        case .guitarDropCSharp:
            return "Drop C♯"
        case .guitarDropC:
            return "Drop C"
        case .guitarDropB:
            return "Drop B"
        case .guitarDropA:
            return "Drop A"
        case .guitarDADGAD:
            return "DADGAD"
        case .guitarOpenG:
            return "Open G"
        case .guitarOpenD:
            return "Open D"
        case .guitarOpenE:
            return "Open E"
        case .guitarDoubleDropD:
            return "Double Drop D"
        case .guitarNashville:
            return "Nashville"
        case .guitarNewStandard:
            return "New Standard (Fripp)"
        case .guitarRainSong:
            return "Rain Song"
        }
    }
    
    var pitches: [Pitch] {
        switch self {
        // MARK: - Standard & Step-Down Variations
        case .guitarStandard:
            // E-A-D-G-B-E
            return [
                Pitch(pitchClass: .e, octave: 2),
                Pitch(pitchClass: .a, octave: 2),
                Pitch(pitchClass: .d, octave: 3),
                Pitch(pitchClass: .g, octave: 3),
                Pitch(pitchClass: .b, octave: 3),
                Pitch(pitchClass: .e, octave: 4)
            ]
        case .guitarHalfStepDown:
            // Eb-Ab-Db-Gb-Bb-Eb
            return [
                Pitch(pitchClass: .dSharp, octave: 2),
                Pitch(pitchClass: .gSharp, octave: 2),
                Pitch(pitchClass: .cSharp, octave: 3),
                Pitch(pitchClass: .fSharp, octave: 3),
                Pitch(pitchClass: .aSharp, octave: 3),
                Pitch(pitchClass: .dSharp, octave: 4)
            ]
        case .guitarWholeStepDown:
            // D-G-C-F-A-D (D Standard)
            return [
                Pitch(pitchClass: .d, octave: 2),
                Pitch(pitchClass: .g, octave: 2),
                Pitch(pitchClass: .c, octave: 3),
                Pitch(pitchClass: .f, octave: 3),
                Pitch(pitchClass: .a, octave: 3),
                Pitch(pitchClass: .d, octave: 4)
            ]
        case .guitarCStandard:
            // C-F-Bb-Eb-G-C
            return [
                Pitch(pitchClass: .c, octave: 2),
                Pitch(pitchClass: .f, octave: 2),
                Pitch(pitchClass: .aSharp, octave: 2),
                Pitch(pitchClass: .dSharp, octave: 3),
                Pitch(pitchClass: .g, octave: 3),
                Pitch(pitchClass: .c, octave: 4)
            ]
            
        // MARK: - Drop Tunings
        case .guitarDropD:
            // D-A-D-G-B-E
            return [
                Pitch(pitchClass: .d, octave: 2),
                Pitch(pitchClass: .a, octave: 2),
                Pitch(pitchClass: .d, octave: 3),
                Pitch(pitchClass: .g, octave: 3),
                Pitch(pitchClass: .b, octave: 3),
                Pitch(pitchClass: .e, octave: 4)
            ]
        case .guitarDropCSharp:
            // C#-G#-C#-F#-A#-D#
            return [
                Pitch(pitchClass: .cSharp, octave: 2),
                Pitch(pitchClass: .gSharp, octave: 2),
                Pitch(pitchClass: .cSharp, octave: 3),
                Pitch(pitchClass: .fSharp, octave: 3),
                Pitch(pitchClass: .aSharp, octave: 3),
                Pitch(pitchClass: .dSharp, octave: 4)
            ]
        case .guitarDropC:
            // C-G-C-F-A-D
            return [
                Pitch(pitchClass: .c, octave: 2),
                Pitch(pitchClass: .g, octave: 2),
                Pitch(pitchClass: .c, octave: 3),
                Pitch(pitchClass: .f, octave: 3),
                Pitch(pitchClass: .a, octave: 3),
                Pitch(pitchClass: .d, octave: 4)
            ]
        case .guitarDropB:
            // B-F#-B-E-G#-C#
            return [
                Pitch(pitchClass: .b, octave: 1),
                Pitch(pitchClass: .fSharp, octave: 2),
                Pitch(pitchClass: .b, octave: 2),
                Pitch(pitchClass: .e, octave: 3),
                Pitch(pitchClass: .gSharp, octave: 3),
                Pitch(pitchClass: .cSharp, octave: 4)
            ]
        case .guitarDropA:
            // A-E-A-D-F#-B
            return [
                Pitch(pitchClass: .a, octave: 1),
                Pitch(pitchClass: .e, octave: 2),
                Pitch(pitchClass: .a, octave: 2),
                Pitch(pitchClass: .d, octave: 3),
                Pitch(pitchClass: .fSharp, octave: 3),
                Pitch(pitchClass: .b, octave: 3)
            ]
            
        // MARK: - Alternate & Open Tunings
        case .guitarDADGAD:
            // D-A-D-G-A-D (Celtic/Folk)
            return [
                Pitch(pitchClass: .d, octave: 2),
                Pitch(pitchClass: .a, octave: 2),
                Pitch(pitchClass: .d, octave: 3),
                Pitch(pitchClass: .g, octave: 3),
                Pitch(pitchClass: .a, octave: 3),
                Pitch(pitchClass: .d, octave: 4)
            ]
        case .guitarOpenG:
            // D-G-D-G-B-D (Keith Richards/Rolling Stones)
            return [
                Pitch(pitchClass: .d, octave: 2),
                Pitch(pitchClass: .g, octave: 2),
                Pitch(pitchClass: .d, octave: 3),
                Pitch(pitchClass: .g, octave: 3),
                Pitch(pitchClass: .b, octave: 3),
                Pitch(pitchClass: .d, octave: 4)
            ]
        case .guitarOpenD:
            // D-A-D-F#-A-D
            return [
                Pitch(pitchClass: .d, octave: 2),
                Pitch(pitchClass: .a, octave: 2),
                Pitch(pitchClass: .d, octave: 3),
                Pitch(pitchClass: .fSharp, octave: 3),
                Pitch(pitchClass: .a, octave: 3),
                Pitch(pitchClass: .d, octave: 4)
            ]
        case .guitarOpenE:
            // E-B-E-G#-B-E
            return [
                Pitch(pitchClass: .e, octave: 2),
                Pitch(pitchClass: .b, octave: 2),
                Pitch(pitchClass: .e, octave: 3),
                Pitch(pitchClass: .gSharp, octave: 3),
                Pitch(pitchClass: .b, octave: 3),
                Pitch(pitchClass: .e, octave: 4)
            ]
        case .guitarDoubleDropD:
            // D-A-D-G-B-D
            return [
                Pitch(pitchClass: .d, octave: 2),
                Pitch(pitchClass: .a, octave: 2),
                Pitch(pitchClass: .d, octave: 3),
                Pitch(pitchClass: .g, octave: 3),
                Pitch(pitchClass: .b, octave: 3),
                Pitch(pitchClass: .d, octave: 4)
            ]
            
        // MARK: - Specialist & Modern Tunings
        case .guitarNashville:
            // E-A-D-G-B-E (Lower 4 strings an octave higher)
            return [
                Pitch(pitchClass: .e, octave: 3),
                Pitch(pitchClass: .a, octave: 3),
                Pitch(pitchClass: .d, octave: 4),
                Pitch(pitchClass: .g, octave: 4),
                Pitch(pitchClass: .b, octave: 3),
                Pitch(pitchClass: .e, octave: 4)
            ]
        case .guitarNewStandard:
            // C-G-D-A-E-G (Robert Fripp/King Crimson)
            return [
                Pitch(pitchClass: .c, octave: 2),
                Pitch(pitchClass: .g, octave: 2),
                Pitch(pitchClass: .d, octave: 3),
                Pitch(pitchClass: .a, octave: 3),
                Pitch(pitchClass: .e, octave: 4),
                Pitch(pitchClass: .g, octave: 4)
            ]
        case .guitarRainSong:
            // D-G-C-G-C-D (Led Zeppelin's "The Rain Song")
            return [
                Pitch(pitchClass: .d, octave: 2),
                Pitch(pitchClass: .g, octave: 2),
                Pitch(pitchClass: .c, octave: 3),
                Pitch(pitchClass: .g, octave: 3),
                Pitch(pitchClass: .c, octave: 4),
                Pitch(pitchClass: .d, octave: 4)
            ]
        }
    }
}
