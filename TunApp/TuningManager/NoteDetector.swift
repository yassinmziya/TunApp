//
//  NoteDetector.swift
//  TunApp
//
//  Created by Yassin Mziya on 11/29/25.
//

import Foundation

class NoteDetector {
    
    private let octave0LowerBound = Pitch(pitchClass: .c, octave: 0)
    private let octave0UpperBound = Pitch(pitchClass: .c, octave: 0)
    
    
    private let octaveZeroChromaticScale = [
        Pitch(pitchClass: .c, octave: 0), // ~16.35 Hz
        Pitch(pitchClass: .cSharp, octave: 0), // ~17.32 Hz
        Pitch(pitchClass: .d, octave: 0), // ~18.35 Hz
        Pitch(pitchClass: .dSharp, octave: 0), // ~19.45 Hz
        Pitch(pitchClass: .e, octave: 0), // ~20.60 Hz
        Pitch(pitchClass: .f, octave: 0), // ~21.83 Hz
        Pitch(pitchClass: .fSharp, octave: 0), // ~23.12 Hz
        Pitch(pitchClass: .g, octave: 0), // ~24.50 Hz
        Pitch(pitchClass: .gSharp, octave: 0), // ~25.96 Hz
        Pitch(pitchClass: .a, octave: 0), // ~27.50 Hz
        Pitch(pitchClass: .aSharp, octave: 0), // ~29.14 Hz
        Pitch(pitchClass: .b, octave: 0), // ~30.87 Hz
    ]
    
    struct NoteDetection {
        let pitch: Pitch
        let frequency: Float
        let deviation: Float
    }
    
    func detectNote(measuredFrequency: Float) -> NoteDetection? {
        let normalizedFrequency = mapToBaseOctave(measuredFrequency)
        guard let detectedPitchClass = closestPitch(to: normalizedFrequency, in: octaveZeroChromaticScale)?.pitchClass else {
            return nil
        }
        
        let octave = Int(log2f(measuredFrequency / octave0LowerBound.frequency()))
        let detectedPitch = Pitch(pitchClass: detectedPitchClass, octave: octave)
        let deviation = calculateDeviation(from: measuredFrequency, to: detectedPitch)
        
        return NoteDetection(
            pitch: detectedPitch,
            frequency: normalizedFrequency,
            deviation: deviation
        )
    }
    
    func detectNote(
        measuredFrequency: Float,
        selectedPitch: Pitch
    ) -> NoteDetection {
        let deviation = calculateDeviation(from: measuredFrequency, to: selectedPitch)
        return NoteDetection(
            pitch: selectedPitch,
            frequency: measuredFrequency,
            deviation: deviation)
    }
    
    func detectNote(
        measuredFrequency: Float,
        tuningPreset: TuningPreset,
    ) -> NoteDetection? {
        guard let detectedPitch = closestPitch(to: measuredFrequency, in: tuningPreset.pitches) else {
            return nil
        }
        let deviation = calculateDeviation(from: measuredFrequency, to: detectedPitch)
        return NoteDetection(
            pitch: detectedPitch,
            frequency: measuredFrequency,
            deviation: deviation
        )
    }
    
    private func mapToBaseOctave(_ frequency: Float) -> Float {
        var frequency = frequency
        while frequency > Float(octave0LowerBound.frequency()) {
            frequency /= 2.0
        }
        while frequency < Float(octave0UpperBound.frequency()) {
            frequency *= 2.0
        }
        return frequency
    }
    
    private func calculateDeviation(from frequency: Float, to pitch: Pitch, deadzone: Float = 5.0) -> Float {
        var deviation = 1200 * log2f(frequency/pitch.frequency()) // in cents
        if abs(deviation) < deadzone {
            deviation = 0.0
        }
        return deviation
    }
    
    private func closestPitch(to frequency: Float, in possiblePitches: [Pitch]) -> Pitch? {
        var minDistance: Float = .greatestFiniteMagnitude
        var detectedPitch: Pitch?
        for pitch in possiblePitches {
            let distance = fabsf(pitch.frequency() - frequency)
            if distance < minDistance {
                detectedPitch = pitch
                minDistance = distance
            }
        }
        return detectedPitch
    }
}
