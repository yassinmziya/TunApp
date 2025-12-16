//
//  Tuner.swift
//  TunApp
//
//  Created by Yassin Mziya on 10/13/25.
//

import SwiftUI

struct Tuner: View {
    
    @State var showSheet = true
    @EnvironmentObject var tuningManager: TuningManager
    
    var body: some View {
        ZStack {
            Grid()
            VStack {
                HStack {
                    Text(TuningUtils.flatSymbol)
                        .font(.system(size: 36))
                    Spacer()
                    Text(TuningUtils.sharpSymbol)
                        .font(.system(size: 36))
                }
                .padding()
                Spacer()
            }
        }
        .sheet(isPresented: $showSheet) {
            MainContent()
        }
    }
}

private struct MainContent: View {
    
    @EnvironmentObject var tuningManager: TuningManager
    @State var usingFlats = true
    
    var body: some View {
        VStack {
            Spacer()
            let note = tuningManager.data.note
            let noteName = note?.name(usingFlats: usingFlats)
            let octave = note != nil ? String(tuningManager.data.ocatave) : ""
            Text(noteName ?? "-")
                .font(.system(size: 96))
            + Text("\(octave)")
                .font(.system(size: 48))
                .baselineOffset(36)
            
            Text("Frequency: \(Int(tuningManager.data.pitch)) Hz")
                .font(.system(size: 24))
            Text("Distance: \(tuningManager.data.distance)")
                .font(.system(size: 16))
            Text("Amplitude: \(tuningManager.data.amplitude)")
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
        .presentationDetents([.medium])
        .presentationBackgroundInteraction(.enabled)
        .interactiveDismissDisabled()
    }
}

#Preview {
    Tuner()
        .environmentObject(TuningManager())
}
