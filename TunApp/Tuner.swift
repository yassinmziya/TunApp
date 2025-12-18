//
//  Tuner.swift
//  TunApp
//
//  Created by Yassin Mziya on 10/13/25.
//

import SwiftUI

struct Tuner: View {
    
    @State var showSheet = true
    @Environment(TuningManager.self) var tuningManager
    
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
            SheetContent()
                .environment(tuningManager)
                .presentationDetents([.medium])
                .presentationBackgroundInteraction(.enabled)
                .interactiveDismissDisabled()
        }
    }
}

private struct SheetContent: View {
    
    var body: some View {
        TabView {
            Tab("Chromatic", systemImage: "tuningfork") {
                ChromaticTuner()
            }
            Tab("Presets", systemImage: "guitars") {
                PresetTuner(tuningPreset: .standard)
            }
        }
    }
    
}

#Preview {
    Tuner()
        .environment(TuningManager())
}
