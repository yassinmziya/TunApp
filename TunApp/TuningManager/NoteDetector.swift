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
        let pitch: Pitch
        let adjustedFrequency: Float
        let deviation: Float
    }
    
    func detectNote(measuredFrequency: Float) -> NoteDetection? {
        let adjustedMeasuredFrequency = adjustToReferenceOctaveRange(measuredFrequency)
        
        var minDistance: Float = .greatestFiniteMagnitude
        var detectedPitchClass: PitchClass?
        for possiblePitch in Pitch.referenceRange {
            let distance = fabsf(possiblePitch.frequency() - adjustedMeasuredFrequency)
            if distance < minDistance {
                detectedPitchClass = possiblePitch.pitchClass
                minDistance = distance
            }
        }
        guard let detectedPitchClass else {
            return nil
        }
        
        let octave = Int(log2f(measuredFrequency / adjustedMeasuredFrequency))
        let detectedPitch = Pitch(pitchClass: detectedPitchClass, octave: octave)
        
        var deviation = 1200 * log2f(adjustedMeasuredFrequency/detectedPitch.frequency()) // in cents
        if abs(deviation) < deadzoneThreshold {
            deviation = 0.0
        }
        
        return NoteDetection(
            pitch: detectedPitch,
            adjustedFrequency: adjustedMeasuredFrequency,
            deviation: deviation
        )
    }
    
    func detectNote(
        measuredFrequency: Float,
        targetPitch: Pitch
    ) -> NoteDetection {
        let targetFrequency = targetPitch.frequency()
        var deviation = 1200 * log2f(measuredFrequency/targetFrequency) // in cents
        if abs(deviation) < deadzoneThreshold {
            deviation = 0.0
        }
        return NoteDetection(
            pitch: targetPitch,
            adjustedFrequency: measuredFrequency,
            deviation: deviation)
    }
    
    func detectNote(
        measuredFrequency: Float,
        tuningPreset: TuningPreset,
    ) -> NoteDetection? {
        var minDistance: Float = .greatestFiniteMagnitude
        var detectedPitch: Pitch?
        for possiblePitch in tuningPreset.pitches {
            let distance = fabsf(possiblePitch.frequency() - measuredFrequency)
            if distance < minDistance {
                detectedPitch = possiblePitch
                minDistance = distance
            }
        }
        
        guard let detectedPitch else {
            return nil
        }
        
        var deviation = 1200 * log2f(measuredFrequency/detectedPitch.frequency()) // in cents
        if abs(deviation) < deadzoneThreshold {
            deviation = 0.0
        }
        
        return NoteDetection(
            pitch: detectedPitch,
            adjustedFrequency: measuredFrequency,
            deviation: deviation
        )
    }
    
    /**
     Maps the given pitch value to hardcoded octave represented by `Pitch.referenceRange` array
     
     Discussion:
     An octave is a fundamental musical interval defined by a frequency ratio of 2:1.
     Higher Octave: Doubling the frequency (f * 2) raises the pitch by exactly one octave.
     Lower Octave: Halving the frequency (f / 2 or f * 0.5) lowers the pitch by exactly one octave.
    
     For example, the musical note A4 (the A above middle C) has a standard frequency of 440 Hz. The note A3, which is one octave lower, has a frequency of 220 Hz.
     */
    private func adjustToReferenceOctaveRange(_ frequency: Float) -> Float {
        var frequency = frequency
        while frequency > Float(Pitch.referenceRange.last!.frequency()) {
            frequency /= 2.0
        }
        while frequency < Float(Pitch.referenceRange.first!.frequency()) {
            frequency *= 2.0
        }
        return frequency
    }
}
