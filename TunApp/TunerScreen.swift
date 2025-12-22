//
//  TunerScreen.swift
//  TunApp
//
//  Created by Yassin Mziya on 10/13/25.
//

import SwiftUI

 // MARK: - TunerScreen

struct TunerScreen: View {
    
    @Environment(TuningManager.self) var tuningManager
    
    @State private var showSheet = true 
    @State private var presentationDetent = PresentationDetent.fraction60
    
    var body: some View {
        ZStack {
            Grid()
            VStack {
                HStack {
                    Text(String.flatSymbol)
                        .font(.system(size: 36))
                    Spacer()
                    Text(String.sharpSymbol)
                        .font(.system(size: 36))
                }
                .padding()
                Spacer()
            }
        }
        .sheet(isPresented: $showSheet) {
            SheetContent(presentationDetent: $presentationDetent)
                .environment(tuningManager)
                .presentationDetents([.fraction60, .large], selection: $presentationDetent)
                .presentationBackgroundInteraction(.enabled)
                .interactiveDismissDisabled()
        }
    }
}

private struct SheetContent: View {
    
    @Environment(TuningManager.self) var tuningManager
    
    @State private var showSettings = false
    @Binding var presentationDetent: PresentationDetent
    
    var body: some View {
        NavigationStack {
            VStack {
                Group {
                    if showSettings {
                        SettingsScreen()
                    } else {
                        if let tuningPreset = tuningManager.tuningPreset {
                            PresetTuner(tuningPreset: tuningPreset)
                        } else {
                            ChromaticTuner()
                        }
                    }
                }
            }
            .onChange(of: presentationDetent, { _, newValue in
                withAnimation {
                    showSettings = newValue == PresentationDetent.large
                }
            })
            .toolbar {
                if showSettings {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Close settings", systemImage: "xmark", action: didTapCloseCta)
                    }
                } else {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Settings", systemImage: "gear", action: didTapSettingsCta)
                    }
                }
            }
        }
    }
    
    private func didTapSettingsCta() {
        withAnimation {
            showSettings = true
            presentationDetent = .large
        }
    }
    
    private func didTapCloseCta() {
        withAnimation {
            showSettings = false
            presentationDetent = .fraction60
        }
    }
    
}

// MARK: - PresentationDetent + Utils

extension PresentationDetent {
    
    static var fraction60: PresentationDetent {
        return .fraction(0.6)
    }
}

#Preview {
    TunerScreen()
        .environment(TuningManager())
}
