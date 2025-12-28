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
import Combine

@Observable
class TuningManager: HasAudioEngine {
    
    // MARK: Constants
    
    private let sustainInterval = 0.05 // seconds
    private let maxSustainDuration = 1.0 // seconds
    
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

    private var sustainPreviousTuningDataTimer: AnyCancellable?
    
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
                if (tuningData != nil) {
                    startSustainTimer() // sustain timer will eventually set value to nil
                }
                return
            }
            stopSustainTimer()
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
            startSustainTimer()
        }
    }
    
    func enableChromaticTuning() {
        self.instrument = .chromatic
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
        updatePreset(defaultPreset)
    }
    
    func updatePreset(_ tuningPreset: TuningPreset) {
        self.tuningPreset = tuningPreset
        self.selectedPitch = tuningPreset.pitches.first
    }
    
    func updateSelectedPitch(_ selectedPitch: Pitch) {
        self.isAutoDetectionEnabled = false
        self.selectedPitch = selectedPitch
    }
    
    func toggleAutoDetection(_ isEnabled: Bool) {
        isAutoDetectionEnabled = isEnabled
        if isEnabled {
            selectedPitch = nil
        }
    }
    
    // MARK: - Private
    
    private func startSustainTimer() {
        guard sustainPreviousTuningDataTimer == nil else { return }
        sustainPreviousTuningDataTimer = Timer.publish(every: 0.05, on: .main, in: .common)
            .autoconnect()
            .prefix(Int(maxSustainDuration/sustainInterval))
            .sink(receiveCompletion: { [weak self] _ in
                // Logic to execute when the max repeats are reached
                self?.stopSustainTimer()
                print("Sustain limit reached - timer killed")
            }, receiveValue: { [weak self] _ in
                guard let self = self else { return }
                // Force the update notification
                self.tuningData = self.tuningData?.copy()
                print("Sustain tick")
            })
    }
    
    private func stopSustainTimer() {
        sustainPreviousTuningDataTimer?.cancel()
        sustainPreviousTuningDataTimer = nil
        self.tuningData = nil
    }
}

// MARK: - NoteDetection + Utils

fileprivate extension NoteDetector.NoteDetection {
    
    func tuningData(amplitude: Float) -> TuningData {
        return TuningData(
            pitch: pitch,
            frequency: frequency,
            amplitude: amplitude,
            distance: deviation
        )
    }
}
