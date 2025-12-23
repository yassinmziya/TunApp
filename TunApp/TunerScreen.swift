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
                    SheetHeader(
                        tuningManager: tuningManager,
                        didTapSettingsCta: didTapSettingsCta
                    )
                    Spacer()
                }
                Group {
                    if showSettings {
                        SettingsScreen(tuningManager: tuningManager, handleDismiss: didTapCloseSettingsCta)
                    } else {
                        if let tuningPreset = tuningManager.tuningPreset {
                            PresetTuner(tuningPreset: tuningPreset)
                        } else {
                            ChromaticTuner()
                        }
                    }
                }
                Spacer()
            }
            .onChange(of: presentationDetent, { _, newValue in
                withAnimation {
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
    
    let tuningManager: TuningManager
    let didTapSettingsCta: (() -> Void)?
    @State var isAutoTuningModeEnabled: Bool
    
    init(
        tuningManager: TuningManager,
        didTapSettingsCta: (() -> Void)? = nil
    ) {
        self.tuningManager = tuningManager
        self.isAutoTuningModeEnabled = tuningManager.isAutoTuningModeEnabled
        self.didTapSettingsCta = didTapSettingsCta
    }
    
    var body: some View {
        HStack {
            TunerSettingsButton()
                .onTapGesture {
                    didTapSettingsCta?()
                }
            Spacer()
            VStack(spacing: 4) {
                Toggle("Auto", isOn: $isAutoTuningModeEnabled)
            }
            .fixedSize()
        }
        .padding()
        .padding(.top, 16)
        .onChange(of: isAutoTuningModeEnabled) { _, newValue in
            tuningManager.toggleAutoTuningMode(newValue)
        }
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
                    Image(systemName: "chevron.right")
                }
                if let tuningPreset = tuningManager.tuningPreset {
                    Text(tuningPreset.rawValue)
                        .font(.system(size: 16))
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
        }
        .fixedSize()
        .padding(.all, 8)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray)
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
