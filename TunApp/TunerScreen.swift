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

// MARK: - SheetContent

private struct SheetContent: View {
    
    @Environment(TuningManager.self) var tuningManager
    
    @State private var showSettings = false
    @Binding var presentationDetent: PresentationDetent
    
    var body: some View {
        NavigationStack {
            VStack {
                if (!showSettings) {
                    SheetHeader(didTapSettingsCta: didTapSettingsCta)
                    Spacer()
                }
                Group {
                    if showSettings {
                        SettingsScreen(tuningManager: tuningManager, handleDismiss: didTapCloseSettingsCta)
                    } else {
                        if let tuningPreset = tuningManager.tuningPreset {
                            PresetTuner(tuningPreset: tuningPreset, isAutoDetectionEnabled: tuningManager.isAutoDetectionEnabled)
                        } else {
                            ChromaticTuner()
                        }
                    }
                }
                Spacer()
            }
            .onChange(of: presentationDetent, { _, newValue in
                withAnimation(.easeInOut(duration: 0.1)) {
                    showSettings = newValue == PresentationDetent.large
                }
            })
        }
    }
    
    private func didTapSettingsCta() {
        withAnimation {
            showSettings = true
            presentationDetent = .large
        }
    }
    
    private func didTapCloseSettingsCta() {
        withAnimation {
            showSettings = false
            presentationDetent = .fraction60
        }
    }
    
}

// MARK: - SheetHeader

fileprivate struct SheetHeader: View {
    
    @Environment(TuningManager.self) var tuningManager

    let didTapSettingsCta: (() -> Void)?
    
    var body: some View {
        let subheading = tuningManager.tuningPreset?.displayName ?? "All 12 Semi-tones"
        HStack {
            VStack(alignment: .leading) {
                Text(tuningManager.instrument.rawValue)
                    .font(.title.bold())
                Text(subheading)
                    .font(.title.bold())
                    .foregroundStyle(.accent)
            }
            
            Spacer()
            
            IconButton(iconImage: Image(systemName: "gearshape.fill"), style: .primary) {
                didTapSettingsCta?()
            }
        }
        .padding()
        .padding(.top, 12)
    }
}

// MARK: - TunerSettingsButton

fileprivate struct TunerSettingsButton: View {
    
    @Environment(TuningManager.self) var tuningManager
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(tuningManager.instrument.rawValue)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.accent)
                    Image(systemName: "chevron.right")
                        .renderingMode(.template)
                        .foregroundStyle(.accent)
                }
                if let tuningPreset = tuningManager.tuningPreset {
                    Text(tuningPreset.displayName)
                        .font(.system(size: 16))
                        .foregroundStyle(.accent)
                }
            }
            Spacer()
        }
        .fixedSize()
        .padding(.all, 8)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.accent)
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
