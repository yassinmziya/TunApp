//
//  SettingsScreen.swift
//  TunApp
//
//  Created by Yassin Mziya on 12/20/25.
//

import SwiftUI

fileprivate let OUTLINE_WIDTH: CGFloat = 1

// MARK: - SettingsScreen

struct SettingsScreen: View {
    
    private let tuningManager: TuningManager
    
    @State private var selectedInstrument: Instrument
    private var handleDismiss: (() -> Void)?
    
    init(
        tuningManager: TuningManager,
        handleDismiss: (() -> Void)? = nil
    ) {
        self.tuningManager = tuningManager
        self.selectedInstrument = tuningManager.instrument
        self.handleDismiss = handleDismiss
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .center, spacing: 24) {
                HStack {
                    Text("Settings")
                        .font(.largeTitle.bold())
                    Spacer()
                    IconButton(
                        iconImage: Image(systemName: "xmark"),
                        style: .secondary
                    ) {
                        handleDismiss?()
                    }
                }
                .padding(.top)
                
                SettingsSection(title: "Select Instrument") {
                    ScrollView(.horizontal,showsIndicators: false) {
                        HStack(alignment: .center) {
                            ForEach(Instrument.allCases) { instrument in
                                InstrumentCard(
                                    instrument: instrument,
                                    isSelected: selectedInstrument == instrument
                                )
                                .onTapGesture {
                                    didSelectInstrument(instrument: instrument)
                                }
                            }
                        }
                    }
                }
                .scrollClipDisabled(true)
                    
                VStack(alignment: .leading, spacing: 12) {
                    if (selectedInstrument.tuningPresets.isNotEmpty) {
                        SettingsSection(title: "Tuning Presets") {
                            ForEach(selectedInstrument.tuningPresets) { tuningPreset in
                                let isSelected = tuningPreset == tuningManager.tuningPreset
                                TuningPresetRow(
                                    tuningPreset: tuningPreset,
                                    isSelected: isSelected)
                                .onTapGesture {
                                    withAnimation(.linear(duration: 0.05)) {
                                        didSelectTuningPreset(tuningPreset: tuningPreset)
                                    }
                                }
                            }
                        }
                    } else if case .chromatic = selectedInstrument {
                        VStack(spacing: 16) {
                            Image(systemName: "tuningfork")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundStyle(.chromeJack)
                            Text("FULL CHROMATIC RANGE")
                                .font(.headline.weight(.heavy).italic())
                                .foregroundStyle(.accent)
                            Text("Tuning is automatic. The application will detect the nearest semitone and guide you to the target frequency.")
                                .font(.system(size: 12))
                                .foregroundStyle(.textMeta)
                                .multilineTextAlignment(.center)
                        }
                        .frame(width: 256)
                        .padding(.top, 48)
                    }
                }
                Spacer()
            }
        }
        // @max Nice!
        .scrollClipDisabled(true)
        .padding()
        .background(.canvas)
    }
    
    private func didSelectInstrument(instrument: Instrument) {
        selectedInstrument = instrument
        if case .chromatic = instrument {
            tuningManager.enableChromaticTuning()
            return
        }
        tuningManager.updateInstrument(instrument)
    }
    
    private func didSelectTuningPreset(tuningPreset: TuningPreset) {
        tuningManager.updatePreset(tuningPreset)
    }
}

// MARK: - InstrumentCard

fileprivate struct InstrumentCard: View {
    
    let instrument: Instrument
    let isSelected: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack {
                Text(instrument.rawValue)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(isSelected ? .text : .text)
            }
            .frame(width: 140, height: 80)
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .inset(by: OUTLINE_WIDTH/2.0)
                    .stroke(isSelected ? .accent : .border)
            }
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        isSelected
                        ? .accent
                        : .card
                    )
            }
            .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 12))
        }
    }
}

// MARK: - TuningPresetRow

fileprivate struct TuningPresetRow: View {
    
    let tuningPreset: TuningPreset
    let isSelected: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(tuningPreset.displayName)
                    .font(.system(size: 16).weight(.heavy))
                    .foregroundStyle(isSelected ? .accent : .text)
                HStack {
                    ForEach(tuningPreset.pitches) { pitch in
                        Text(noteName(tuningNote: pitch))
                            .font(
                                .system(size: 12)
                                .weight(.heavy)
                            )
                            .padding(.all, 4)
                            .background {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(.canvas)
                                    .stroke(.border)
                            }
                    }
                }
            }
            
            Spacer()
            
            ZStack {
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.accent)
                }
            }
            .frame(width: 24, height: 24)
            .overlay {
                Circle()
                    .stroke(.border)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12.0)
                .fill(isSelected ? .cardSelected : .card)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 12.0)
                .stroke(isSelected ? .accent : . border)
        }
        .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 12))
    }
    
    private func noteName(tuningNote: Pitch) -> String {
        return "\(tuningNote.pitchClass.name())\(tuningNote.octave)"
    }
}

#Preview {
    SettingsScreen(tuningManager: TuningManager())
}


// MARK: - SettingsSectionHeader

fileprivate struct SettingsSectionHeader: View {
    
    let title: String
    
    var body: some View {
        Text(title.uppercased())
            .font(.subheadline.weight(.heavy).italic())
            .foregroundStyle(.chromeJack)
    }
}

// MARK: - SettingsSection

fileprivate struct SettingsSection<Content>: View where Content: View {
    
    let title: String
    let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SettingsSectionHeader(title: title)
            content()
        }
    }
}
