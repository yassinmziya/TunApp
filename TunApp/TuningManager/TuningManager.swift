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
    
    let engine = AudioEngine()
    
    private let initialDevice: Device
    private let mic: AudioEngine.InputNode
    private let tappableNodeA: Fader
    private let tappableNodeB: Fader
    private let tappableNodeC: Fader
    private let silence: Fader
    
    private lazy var tracker = PitchTap(mic) { pitch, amp in
        DispatchQueue.main.async {
            self.update(pitch[0], amp[0])
        }
    }
    
    init() {
        guard let input = engine.input else { fatalError() }
        
        guard let device = engine.inputDevice else { fatalError() }
        
        initialDevice = device
        
        mic = input
        tappableNodeA = Fader(mic)
        tappableNodeB = Fader(tappableNodeA)
        tappableNodeC = Fader(tappableNodeB)
        silence = Fader(tappableNodeC, gain: 0)
        engine.output = silence
        tracker.start()
    }
    
    func update(_ pitch: AUValue, _ amp: AUValue) {
        // Reduce sensitivity to background noise to prevent random / fluctuating data.
        guard amp > 0.1 else { return }
        
        data.pitch = pitch
        data.amplitude = amp
        
        // Map pitch to hardcoded octave represented by noteFrequencies array
        let frequency = TuningUtils.getOcataveFrequency(for: pitch)
        
        // Determine closest possible note mapping
        var minDistance: Float = 10000.0
        var index = 0
        for possibleIndex in 0 ..< TuningUtils.noteFrequencies.count {
            let distance = fabsf(Float(TuningUtils.noteFrequencies[possibleIndex]) - frequency)
            if distance < minDistance {
                index = possibleIndex
                minDistance = distance
            }
        }
        let octave = Int(log2f(pitch / frequency))
        data.noteIndex = index
        data.ocatave = octave
    }
}
