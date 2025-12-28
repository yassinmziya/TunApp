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
        guard let pitchClass =  tuningData?.pitch.pitchClass else {
            return "-"
        }
        return pitchClass.name(usingFlats: usingFlats)
    }
    
    var octave: String {
        guard let octave = tuningData?.pitch.octave else {
            return ""
        }
        return String(octave)
    }
    
    
    var body: some View {
        VStack {
            Spacer()
            Group {
                Text(noteName)
                    .font(.system(size: 104))
                + Text("\(octave)")
                    .font(.system(size: 56))
            }
            .foregroundStyle(.accent)
            
            if let frequency = tuningData?.frequency {
                Text("\(Int(frequency)) Hz")
                    .font(.system(size: 24))
                    .foregroundStyle(.chromeJack)
            }
//            Text("Distance: \(tuningData?.distance ?? 0)")
//                .font(.system(size: 16))
//            Text("Amplitude: \(tuningData?.amplitude ?? 0)")
//                .font(.system(size: 16))
            Spacer()
            HStack {
                Spacer()
                Toggle(isOn: $usingFlats) {
                    Text("\(usingFlats ? String.flatSymbol : String.sharpSymbol)")
                }
                .fixedSize()
                .padding()
                .tint(.accent)
            }
        }
    }
}

#Preview {
    ChromaticTuner()
        .environment(TuningManager())
}
