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
    
    // MARK: Settings
    
    private(set) var tuningPreset: TuningPreset? = .standard {
        didSet {
            #if DEBUG
            if tuningPreset == nil {
                assert(instrument == .chromatic, "tuning preset may only be nil when using chromatic tuner")
            }
            #endif
        }
    }
    private(set) var selectedPitch: Pitch?
    private(set) var instrument: Instrument = .acousticGuitar
    private(set) var isAutoDetectionEnabled = false
    
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
        
        // initial settings
        updateInstrument(.acousticGuitar)
        toggleAutoDetection(true)
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
            guard let processedFrequency = self.signalProcessor.process(pitch, amplitude: amp) else {
                self.tuningData = nil
                return
            }
            var noteDetection: NoteDetector.NoteDetection?
            if let tuningPreset {
                if isAutoDetectionEnabled {
                    noteDetection = noteDetector.detectNote(
                        measuredFrequency: processedFrequency,
                        tuningPreset: tuningPreset
                    )
                    selectedPitch = noteDetection?.pitch
                } else if let selectedPitch {
                    noteDetection = noteDetector.detectNote(
                        measuredFrequency: processedFrequency,
                        selectedPitch: selectedPitch)
                }
            } else {
                noteDetection = noteDetector.detectNote(
                    measuredFrequency: processedFrequency)
            }
            self.tuningData = noteDetection?.tuningData(amplitude: amp)
        }
    }
    
    func enableChromaticTuning() {
        self.instrument = .chromatic
        self.isAutoDetectionEnabled = false
        self.selectedPitch = nil
        self.tuningPreset = nil
    }
    
    func updateInstrument(_ instrument: Instrument) {
        guard instrument != . chromatic, let defaultPreset = instrument.tuningPresets.first else {
            #if DEBUG
                assertionFailure("instrument cannot be chromatic or is missing tuning presets")
            #endif
            return
        }
        self.instrument = instrument
        self.isAutoDetectionEnabled = false
        updatePreset(defaultPreset)
    }
    
    func updatePreset(_ tuningPreset: TuningPreset) {
        self.tuningPreset = tuningPreset
        self.selectedPitch = tuningPreset.pitches.first
    }
    
    func updateSelectedPitch(_ selectedPitch: Pitch) {
        self.selectedPitch = selectedPitch
        self.isAutoDetectionEnabled = false
    }
    
    func toggleAutoDetection(_ isEnabled: Bool) {
        isAutoDetectionEnabled = isEnabled
        selectedPitch = nil
    }
}

// MARK: - NoteDetection + Utils

fileprivate extension NoteDetector.NoteDetection {
    
    func tuningData(amplitude: Float) -> TuningData {
        return TuningData(
            pitch: frequency,
            amplitude: amplitude,
            ocatave: pitch.octave,
            distance: deviation,
            note: pitch.pitchClass
        )
    }
}
