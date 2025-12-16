//
//  NoteDetector.swift
//  TunApp
//
//  Created by Yassin Mziya on 11/29/25.
//

import Foundation

class NoteDetector {
    
    private let deadzoneThreshold: Float = 5.0  // cents
    
    struct NoteDetection {
        let note: Note
        let octave: Int
        let adjustedFrequency: Float
        let deviation: Float
    }
    
    func detectNote(measuredFrequency: Float) -> NoteDetection? {
        let adjustedMeasuredFrequency = adjustToReferenceOctaveRange(measuredFrequency)
        
        var minDistance: Float = .greatestFiniteMagnitude
        var detectedNote: Note?
        for possibleNote in Note.allCases {
            let distance = fabsf(possibleNote.referenceFrequency - adjustedMeasuredFrequency)
            if distance < minDistance {
                detectedNote = possibleNote
                minDistance = distance
            }
        }
        guard let detectedNote else {
            return nil
        }
        
        let octave = Int(log2f(measuredFrequency / adjustedMeasuredFrequency))
        
        var deviation = 1200 * log2f(adjustedMeasuredFrequency/detectedNote.referenceFrequency) // in cents
        if abs(deviation) < deadzoneThreshold {
            deviation = 0.0
        }
        
        return NoteDetection(
            note: detectedNote,
            octave: octave,
            adjustedFrequency: adjustedMeasuredFrequency,
            deviation: deviation
        )
    }
    
    func detectNote(
        measuredFrequency: Float,
        tuningNote: TuningNote
    ) -> NoteDetection {
        let targetFrequency = tuningNote.note.frequency(for: tuningNote.octave)
        var deviation = 1200 * log2f(measuredFrequency/targetFrequency) // in cents
        if abs(deviation) < deadzoneThreshold {
            deviation = 0.0
        }
        return NoteDetection(
            note: tuningNote.note,
            octave: tuningNote.octave,
            adjustedFrequency: measuredFrequency,
            deviation: deviation)
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
        while frequency > Float(Note.allCases.last!.referenceFrequency) {
            frequency /= 2.0
        }
        while frequency < Float(Note.allCases.first!.referenceFrequency) {
            frequency *= 2.0
        }
        return frequency
    }
}
