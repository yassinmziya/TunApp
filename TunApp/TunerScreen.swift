//
//  TunerScreen.swift
//  TunApp
//
//  Created by Yassin Mziya on 10/13/25.
//

import SwiftUI

struct TunerScreen: View {
    
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
    
    private enum SheetTab: Int {
        case chromatic = 0, presets
    }
    
    @Environment(TuningManager.self) var tuningManager
    
    @State private var selection: SheetTab = .chromatic
    
    var body: some View {
        TabView(selection: $selection) {
            Tab("Chromatic", systemImage: "tuningfork", value: SheetTab.chromatic) {
                ChromaticTuner()
            }
            Tab("Presets", systemImage: "guitars", value: SheetTab.presets) {
                PresetTuner(tuningPreset: .standard)
            }
        }
        .glassEffect()
        .onChange(of: selection) { oldValue, newValue in
            switch newValue {
            case .chromatic:
                tuningManager.tuningPreset = nil
                tuningManager.tuningNote = nil
            default:
                tuningManager.tuningPreset = .standard
                tuningManager.tuningNote = nil
            }
        }
    }
    
}

#Preview {
    TunerScreen()
        .environment(TuningManager())
}
