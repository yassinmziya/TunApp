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
    
    // We apply Exponential Moving Average (EMA) to smooth collected signal
    // Add smoothing constants and state
    private let pitchSmoothingFactor: Float = 0.3  // 0.0 = no change, 1.0 = instant
    private let distanceSmoothingFactor: Float = 0.4
    private var smoothedPitch: Float = 0.0
    private var smoothedDistance: Float = 0.0
    
    func update(_ pitch: AUValue, _ amp: AUValue) {
        // Reduce sensitivity to background noise to prevent random / fluctuating data.
        guard amp > 0.1 else { return }
        
        // Apply exponential moving average to pitch
        if smoothedPitch == 0.0 {
            smoothedPitch = pitch
        } else {
            smoothedPitch = smoothedPitch * (1.0 - pitchSmoothingFactor) + pitch * pitchSmoothingFactor
        }
        
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
        let octave = Int(log2f(smoothedPitch / frequency))
                
        let rawDistance = frequency - Float(TuningUtils.noteFrequencies[index])
                
        // Smooth the distance separately for needle movement
        smoothedDistance = smoothedDistance * (1.0 - distanceSmoothingFactor) + rawDistance * distanceSmoothingFactor
                
        data.noteIndex = index
        data.ocatave = octave
        data.distance = smoothedDistance
        print(data.distance)
    }
}
