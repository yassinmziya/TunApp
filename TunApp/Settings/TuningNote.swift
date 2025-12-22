//
//  TuningNote.swift
//  TunApp
//
//  Created by Yassin Mziya on 12/22/25.
//

struct TuningNote: Identifiable, Equatable {
    
    let note: Note
    let octave: Int
    
    var id: String {
        return "\(note.name())\(octave)"
    }
}
