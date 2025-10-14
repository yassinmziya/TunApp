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
        DispatchQueue.main.async {
            self.update(pitch[0], amp[0])
        }
    }
    
    init() {
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
        data.distance = frequency - Float(TuningUtils.noteFrequencies[index])
        print(data.distance)
    }
}
