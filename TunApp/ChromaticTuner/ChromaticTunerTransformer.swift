//
//  ChromaticTunerTransformer.swift
//  TunApp
//
//  Created by Yassin Mziya on 1/20/25.
//

class ChromaticTunerTransformer {
    
    func transform(_ tuningData: TuningData) -> ChromaticTunerViewData {
        return ChromaticTunerViewData(
            noteName: TuningUtils.getNoteName(for: tuningData.noteIndex),
            frequency: "\(Int(tuningData.pitch)) Hz",
            prevNoteName: TuningUtils.getNoteName(for: tuningData.noteIndex - 1),
            nextNoteName: TuningUtils.getNoteName(for: tuningData.noteIndex + 1)
        )
    }
}
