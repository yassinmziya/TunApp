//
//  ChromaticTuner.swift
//  TunApp
//
//  Created by Yassin Mziya on 12/17/25.
//

import SwiftUI

struct ChromaticTuner: View {
    
    @Environment(TuningManager.self) var tuningManager
    @State var usingFlats = true
    
    var body: some View {
        VStack {
            Spacer()
            let note = tuningManager.tuningData.note
            let noteName = note?.name(usingFlats: usingFlats)
            let octave = note != nil ? String(tuningManager.tuningData.ocatave) : ""
            Text(noteName ?? "-")
                .font(.system(size: 96))
            + Text("\(octave)")
                .font(.system(size: 48))
                .baselineOffset(36)
            
            Text("Frequency: \(Int(tuningManager.tuningData.pitch)) Hz")
                .font(.system(size: 24))
            Text("Distance: \(tuningManager.tuningData.distance)")
                .font(.system(size: 16))
            Text("Amplitude: \(tuningManager.tuningData.amplitude)")
                .font(.system(size: 16))
            Spacer()
            HStack {
                Spacer()
                Toggle(isOn: $usingFlats) {
                    Text("\(TuningUtils.sharpSymbol)/\(TuningUtils.flatSymbol)")
                }
            }
            .padding()
        }
    }
}

#Preview {
    ChromaticTuner()
        .environment(TuningManager())
}
