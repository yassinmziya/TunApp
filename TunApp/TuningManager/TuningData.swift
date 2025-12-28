//
//  TuningData.swift
//  TunApp
//
//  Created by Yassin Mziya on 1/20/25.
//

import Foundation

struct TuningData: Equatable {
    
    private let id = UUID()
    
    let pitch: Pitch
    let frequency: Float
    let amplitude: Float
    let distance: Float
    
    func copy() -> TuningData {
        return TuningData(pitch: pitch, frequency: frequency, amplitude: amplitude, distance: distance)
    }
}
