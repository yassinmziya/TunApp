//
//  ChromaticTunerTransformer.swift
//  TunApp
//
//  Created by Yassin Mziya on 1/20/25.
//

class ChromaticTunerTransformer {
    
    func transform(_ tuningData: TuningData) -> ChromaticTunerViewData {
        return ChromaticTunerViewData(
            frequency: "\(Int(tuningData.pitch)) Hz"
        )
    }
}
