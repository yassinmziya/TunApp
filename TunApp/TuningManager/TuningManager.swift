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
    
    var tuningData = TuningData()
    var tuningNote: TuningNote? = TuningPreset.standard.notes.first
    
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
        tracker?.start()
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
        tuningData.pitch = noteDetection?.adjustedFrequency ?? 0.0
        tuningData.amplitude = amplitude
        tuningData.ocatave = noteDetection?.octave ?? 0
        tuningData.distance = noteDetection?.deviation ?? 0.0
        tuningData.note = noteDetection?.note
    }
}
