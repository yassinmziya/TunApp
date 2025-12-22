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
    
    var notes: [TuningNote] {
        switch self {
        case .standard:
            return [
                TuningNote(note: .e, octave: 2),
                TuningNote(note: .a, octave: 2),
                TuningNote(note: .d, octave: 3),
                TuningNote(note: .g, octave: 3),
                TuningNote(note: .b, octave: 3),
                TuningNote(note: .e, octave: 4)
            ]
        case .dropD:
            return [
                TuningNote(note: .d, octave: 2),
                TuningNote(note: .a, octave: 2),
                TuningNote(note: .d, octave: 3),
                TuningNote(note: .g, octave: 3),
                TuningNote(note: .b, octave: 3),
                TuningNote(note: .e, octave: 4)
            ]
        case .openG:
            return [
                TuningNote(note: .d, octave: 2),
                TuningNote(note: .g, octave: 2),
                TuningNote(note: .d, octave: 3),
                TuningNote(note: .g, octave: 3),
                TuningNote(note: .b, octave: 3),
                TuningNote(note: .d, octave: 4)
            ]
        }
    }
}
