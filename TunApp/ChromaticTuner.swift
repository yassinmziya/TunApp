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
    
    var tuningData: TuningData? {
        return tuningManager.tuningData
    }
    
    var noteName: String {
        guard let note =  tuningData?.note else {
            return "-"
        }
        return note.name(usingFlats: usingFlats)
    }
    
    var octave: String {
        guard let octave = tuningData?.ocatave else {
            return ""
        }
        return String(octave)
    }
    
    
    var body: some View {
        VStack {
            Spacer()
            Text(noteName)
                .font(.system(size: 96))
            + Text("\(octave)")
                .font(.system(size: 48))
            
            Text("Frequency: \(Int(tuningData?.pitch ?? 0)) Hz")
                .font(.system(size: 24))
            Text("Distance: \(tuningData?.distance ?? 0)")
                .font(.system(size: 16))
            Text("Amplitude: \(tuningData?.amplitude ?? 0)")
                .font(.system(size: 16))
            Spacer()
            HStack {
                Spacer()
                Toggle(isOn: $usingFlats) {
                    Text("\(String.sharpSymbol)/\(String.flatSymbol)")
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
