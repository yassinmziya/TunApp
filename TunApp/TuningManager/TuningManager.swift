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
import SwiftUI

@Observable
class TuningManager: HasAudioEngine {
    
    // MARK: HasAudioEngine
    
    let engine = AudioEngine()
    
    // MARK: Observable data
    
    private(set) var tuningData: TuningData?
    private(set) var tuningPreset: TuningPreset? = .standard {
        didSet {
            #if DEBUG
            if tuningPreset == nil {
                assert(instrument == .chromatic, "tuning preset may only be nil when using chromatic tuner")
            }
            #endif
        }
    }
    var tuningNote: TuningNote?
    private(set) var instrument: Instrument = .acousticGuitar
    var isAutoTuningModeEnabled = true
    
    
    // MARK: Private 
    
    private let signalProcessor = SignalProcessor()
    private let noteDetector = NoteDetector()
    
    private let mic: AudioEngine.InputNode
    private let outputFader: Fader
    private var tracker: PitchTap?
    
    init() {
        guard let mic = engine.input else {
            fatalError("Mic not found")
        }
        self.mic = mic
        
        let tappableNodeA = Fader(mic)
        let tappableNodeB = Fader(tappableNodeA)
        let tappableNodeC = Fader(tappableNodeB)
        let silence = Fader(tappableNodeC, gain: 0)
        self.outputFader = silence
        engine.output = silence
        
        self.tracker = PitchTap(mic) { [weak self] pitch, amp in
            self?.update(pitch[0], amp[0])
        }
    }
    
    func resume() {
        guard !engine.avEngine.isRunning else { return }
        
        do {
            // Restart the engine first
            try engine.start()
            self.tracker = PitchTap(mic) { [weak self] pitch, amp in
                self?.update(pitch[0], amp[0])
            }
            tracker?.start()
            print("Tuner resumed successfully")
        } catch {
            print("Failed to resume tuner: \(error)")
        }
    }

    func pause() {
        tracker?.stop()
        tracker = nil
        engine.stop()
        print("Tuner paused")
    }
    
    func update(_ pitch: AUValue, _ amp: AUValue) {
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            guard let processedPitch = self.signalProcessor.process(pitch, amplitude: amp) else {
                self.tuningData = nil
                return
            }
            var noteDetection: NoteDetector.NoteDetection?
            if tuningPreset != nil {
                if let tuningNote {
                    noteDetection = noteDetector.detectNote(measuredFrequency: processedPitch, tuningNote: tuningNote)
                }
            } else {
                noteDetection = noteDetector.detectNote(measuredFrequency: processedPitch)
            }
            self.tuningData = noteDetection?.tuningData(amplitude: amp)
        }
    }
    
    func setTuningPreset(
        instrument: Instrument,
        tuningPreset: TuningPreset? = nil
    ) {
        self.instrument = instrument
        
        if case .chromatic = instrument {
            self.tuningPreset = nil
            self.tuningNote = nil
            return
        }
        self.tuningPreset = tuningPreset
    }
}

// MARK: - NoteDetection + Utils

fileprivate extension NoteDetector.NoteDetection {
    
    func tuningData(amplitude: Float) -> TuningData {
        return TuningData(
            pitch: adjustedFrequency,
            amplitude: amplitude,
            ocatave: octave,
            distance: deviation,
            note: note
        )
    }
}
