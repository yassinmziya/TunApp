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

class TuningManager: ObservableObject, HasAudioEngine {
    
    @Published var data = TuningData()
    
    var tuningNote: TuningNote? = TuningPreset.standard.notes.first
    
    let engine = AudioEngine()
    
    private lazy var initialDevice = {
        guard let device = engine.inputDevice else {
            fatalError()
        }
        return device
    }()
    
    private lazy var mic = {
        guard let input = engine.input else {
            fatalError()
        }
        return input
    }()
    
    private lazy var tappableNodeA = Fader(mic)
    private lazy var tappableNodeB = Fader(tappableNodeA)
    private lazy var tappableNodeC = Fader(tappableNodeB)
    private lazy var silence =  Fader(tappableNodeC, gain: 0)
    
    private lazy var tracker = PitchTap(mic) { pitch, amp in
        self.update(pitch[0], amp[0])
    }
    
    private lazy var signalProcessor = SignalProcessor()
    private lazy var noteDetector = NoteDetector()
    
    init() {
        engine.output = silence
        tracker.start()
    }
    
    func update(_ pitch: AUValue, _ amp: AUValue) {
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            guard let processedPitch = self.signalProcessor.process(pitch, amplitude: amp) else {
                self.updateData(nil, amplitude: amp)
                return
            }
            var noteDetection: NoteDetector.NoteDetection?
            if let tuningNote {
                noteDetection = noteDetector.detectNote(measuredFrequency: processedPitch, tuningNote: tuningNote)
            } else {
                noteDetection = noteDetector.detectNote(measuredFrequency: processedPitch)
            }
            self.updateData(noteDetection, amplitude: amp)
        }
    }
    
    private func updateData(_ noteDetection: NoteDetector.NoteDetection?, amplitude: Float) {
        data.pitch = noteDetection?.adjustedFrequency ?? 0.0
        data.amplitude = amplitude
        data.ocatave = noteDetection?.octave ?? 0
        data.distance = noteDetection?.deviation ?? 0.0
        data.note = noteDetection?.note
    }
}
