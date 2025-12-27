//
//  TuningData.swift
//  TunApp
//
//  Created by Yassin Mziya on 1/20/25.
//

import Foundation

struct TuningData: Equatable {
    let id = UUID()
    let pitch: Float
    let amplitude: Float
    let ocatave: Int
    let distance: Float
    let note: PitchClass
    
    func copy() -> TuningData {
        return TuningData(pitch: pitch, amplitude: amplitude, ocatave: ocatave, distance: distance, note: note)
    }
}
