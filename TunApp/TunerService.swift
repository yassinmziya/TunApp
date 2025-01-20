//
//  TunerService.swift
//  TunApp
//
//  Created by Yassin Mziya on 1/19/25.
//

import AudioKit
import AudioKitEX
import Foundation
import SoundpipeAudioKit

struct TunerData {
    var pitch: Float = 0.0
    var amplitude: Float = 0.0
    var noteIndex: Int = 0
    var ocatave: Int = 0
    var distance: Float = 0.0
    
    var noteNameWithSharps: String {
        TuningService.shared.getNoteNameWithSharps(noteIndex)
    }
    
    var noteNameWithFlats: String {
        TuningService.shared.getNoteNameWithFlats(noteIndex)
    }
    
    var prevNoteNameWithSharps: String {
        TuningService.shared.getNoteNameWithSharps(noteIndex - 1)
    }
    
    var prevNoteNameWithFlats: String {
        TuningService.shared.getNoteNameWithFlats(noteIndex - 1)
    }
    
    var nextNoteNameWithSharps: String {
        TuningService.shared.getNoteNameWithSharps(noteIndex + 1)
    }
    
    var nextNoteNameWithFlats: String {
        TuningService.shared.getNoteNameWithFlats(noteIndex + 1)
    }
    
}

class TuningService: ObservableObject, HasAudioEngine {
    @Published var data = TunerData()

    let engine = AudioEngine()
    private let initialDevice: Device

    private let mic: AudioEngine.InputNode
    private let tappableNodeA: Fader
    private let tappableNodeB: Fader
    private let tappableNodeC: Fader
    private let silence: Fader

    private var tracker: PitchTap!

    private let noteFrequencies = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    private let noteNamesWithSharps = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
    private let noteNamesWithFlats = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]
    
    static let shared = TuningService()

    private init() {
        guard let input = engine.input else { fatalError() }

        guard let device = engine.inputDevice else { fatalError() }

        initialDevice = device

        mic = input
        tappableNodeA = Fader(mic)
        tappableNodeB = Fader(tappableNodeA)
        tappableNodeC = Fader(tappableNodeB)
        silence = Fader(tappableNodeC, gain: 0)
        engine.output = silence

        tracker = PitchTap(mic) { pitch, amp in
            DispatchQueue.main.async {
                self.update(pitch[0], amp[0])
            }
        }
        tracker.start()
    }

    func update(_ pitch: AUValue, _ amp: AUValue) {
        // Reduce sensitivity to background noise to prevent random / fluctuating data.
        guard amp > 0.1 else { return }

        data.pitch = pitch
        data.amplitude = amp

        // Map pitch to hardcoded octave represented by noteFrequencies array
        var frequency = pitch
        while frequency > Float(noteFrequencies[noteFrequencies.count - 1]) {
            frequency /= 2.0
        }
        while frequency < Float(noteFrequencies[0]) {
            frequency *= 2.0
        }

        // Determine closest possible note mapping
        var minAbsDistance: Float = 10000.0
        var minDistance: Float = 10000.0
        var index = 0
        for possibleIndex in 0 ..< noteFrequencies.count {
            let distance = fabsf(Float(noteFrequencies[possibleIndex]) - frequency)
            if distance < minAbsDistance {
                index = possibleIndex
                minAbsDistance = distance
                minDistance = Float(noteFrequencies[possibleIndex]) - frequency
            }
        }
        let octave = Int(log2f(pitch / frequency))
        data.noteIndex = index
        data.ocatave = octave
        data.distance = minDistance
    }
    
    func getNoteNameWithSharps(_ index: Int) -> String {
        return noteNamesWithSharps[abs(index % noteNamesWithSharps.count)]
    }
    
    func getNoteNameWithFlats(_ index: Int) -> String {
        return noteNamesWithFlats[abs(index % noteNamesWithFlats.count)]
    }
}
