//
//  TuningUtils.swift
//  TunApp
//
//  Created by Yassin Mziya on 1/20/25.
//

class TuningUtils {
    
    static let sharpSymbol = "♯"
    static let flatSymbol = "♭"
    
    static let noteFrequencies = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    private static let noteNamesWithSharps = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
    private static let noteNamesWithFlats = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]
    
    /**
     Maps the given pitch value to hardcoded octave represented by `noteFrequencies` array
     
     Discussion:
     An octave is a fundamental musical interval defined by a frequency ratio of 2:1.
     Higher Octave: Doubling the frequency (f * 2) raises the pitch by exactly one octave.
     Lower Octave: Halving the frequency (f / 2 or f * 0.5) lowers the pitch by exactly one octave.
    
     For example, the musical note A4 (the A above middle C) has a standard frequency of 440 Hz. The note A3, which is one octave lower, has a frequency of 220 Hz.
     */
    static func getOcataveFrequency(for pitch: Float) -> Float {
        var frequency = pitch
        while frequency > Float(noteFrequencies.last!) {
            frequency /= 2.0
        }
        while frequency < Float(noteFrequencies.first!) {
            frequency *= 2.0
        }
        return frequency
    }
    
    static func getNoteNameWithSharps(for index: Int) -> String {
        return noteNamesWithSharps[index % noteNamesWithSharps.count]
    }
    
    static func getNoteName(for index: Int, useSharps: Bool = false) -> String {
        let noteNames = useSharps ? noteNamesWithSharps : noteNamesWithFlats
        return noteNames[abs(index % noteNames.count)]
    }
}

