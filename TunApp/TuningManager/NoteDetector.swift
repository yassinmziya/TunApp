//
//  NoteDetector.swift
//  TunApp
//
//  Created by Yassin Mziya on 11/29/25.
//

import Foundation

class NoteDetector {
    
    private let referenceFrequencies: [Float] =
    [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    private let noteNamesWithSharps = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
    private let noteNamesWithFlats = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]
    
    private let deadzoneThreshold: Float = 5.0  // cents
    
    /**
     Represents a note within the reference window. See: `NoteDetector`
     */
    struct Note {
        let referenceFrequency: Float
        let sharpName: String
        let flatName: String
    }
    
    struct NoteDetection {
        let note: Note
        let octave: Int
        let adjustedFrequency: Float
        let deviation: Float
    }
    
    func detectNote(_ frequency: Float) -> NoteDetection {
        let adjustedFrequency = adjustToReferenceOctaveRange(frequency)
        var minDistance: Float = .greatestFiniteMagnitude
        var index = 0
        for possibleIndex in 0 ..< referenceFrequencies.count {
            let distance = fabsf(Float(referenceFrequencies[possibleIndex]) - adjustedFrequency)
            if distance < minDistance {
                index = possibleIndex
                minDistance = distance
            }
        }
        
        let detectedNote = Note(
            referenceFrequency: referenceFrequencies[index],
            sharpName: noteNamesWithSharps[index],
            flatName: noteNamesWithFlats[index]
        )
        
        let octave = Int(log2f(frequency / adjustedFrequency))
        
        var deviation = 1200 * log2f(adjustedFrequency/detectedNote.referenceFrequency)

        if abs(deviation) < deadzoneThreshold {
            deviation = 0.0
        }
        
        return NoteDetection(
            note: detectedNote,
            octave: octave,
            adjustedFrequency: adjustedFrequency,
            deviation: deviation
        )
    }
    
    /**
     Maps the given pitch value to hardcoded octave represented by `referenceFrequencies` array
     
     Discussion:
     An octave is a fundamental musical interval defined by a frequency ratio of 2:1.
     Higher Octave: Doubling the frequency (f * 2) raises the pitch by exactly one octave.
     Lower Octave: Halving the frequency (f / 2 or f * 0.5) lowers the pitch by exactly one octave.
    
     For example, the musical note A4 (the A above middle C) has a standard frequency of 440 Hz. The note A3, which is one octave lower, has a frequency of 220 Hz.
     */
    private func adjustToReferenceOctaveRange(_ frequency: Float) -> Float {
        var frequency = frequency
        while frequency > Float(referenceFrequencies.last!) {
            frequency /= 2.0
        }
        while frequency < Float(referenceFrequencies.first!) {
            frequency *= 2.0
        }
        return frequency
    }
}
