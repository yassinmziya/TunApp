//
//  SettingsScreen.swift
//  TunApp
//
//  Created by Yassin Mziya on 12/20/25.
//

import SwiftUI

fileprivate let OUTLINE_WIDTH: CGFloat = 1

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
            VStack(alignment: .leading) {
                Text("Instrument")
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
                    .padding(.vertical)
                }
                .scrollClipDisabled(true)
                VStack(alignment: .leading, spacing: 12) {
                    if (selectedInstrument.tuningPresets.isNotEmpty) {
                        Text("Tuning")
                            .padding(.bottom, 8)
                    }
                    ForEach(selectedInstrument.tuningPresets) { tuningPreset in
                        let isSelected = tuningPreset == tuningManager.tuningPreset
                        TuningPresetRow(
                            tuningPreset: tuningPreset,
                            isSelected: isSelected)
                        .onTapGesture {
                            didSelectTuningPreset(tuningPreset: tuningPreset)
                        }
                        
                        Divider()
                            .frame(height: OUTLINE_WIDTH)
                            .overlay(isSelected ? .blue : .gray)
                    }
                }
                Spacer()
            }
        }
        // @max Nice!
        .scrollClipDisabled(true)
        .padding()
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Close settings", systemImage: "xmark") {
                    handleDismiss?()
                }
            }
        }
        
    }
    
    private func didSelectInstrument(instrument: Instrument) {
        selectedInstrument = instrument
        if case .chromatic = instrument {
            tuningManager.setTuningPreset(instrument: instrument)
            return
        }
        tuningManager.setTuningPreset(
            instrument: instrument,
            tuningPreset: instrument.tuningPresets.first
        )
    }
    
    private func didSelectTuningPreset(tuningPreset: TuningPreset) {
        tuningManager.setTuningPreset(
            instrument: selectedInstrument,
            tuningPreset: tuningPreset)
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
            }
            .frame(width: 140, height: 80)
            .overlay {
                if (isSelected) {
                    RoundedRectangle(cornerRadius: 12)
                        .inset(by: OUTLINE_WIDTH/2.0)
                        .stroke(style: .init(lineWidth: OUTLINE_WIDTH))
                    
                }
            }
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        isSelected
                        ? Color.white.opacity(0.5)
                        : Color.white.opacity(0.1)
                    )
            }
            
            if isSelected {
                VStack(alignment: .center) {
                    Image(systemName: "checkmark")
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 16, height: 12)
                        .foregroundStyle(.black.opacity(0.5))
                        .padding(.all, 8)
                        .background {
                            UnevenRoundedRectangle(topLeadingRadius: 12, bottomTrailingRadius: 12)
                        }
                }
            }
        }
    }
}

fileprivate struct TuningPresetRow: View {
    
    let tuningPreset: TuningPreset
    let isSelected: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(tuningPreset.rawValue)
                    .font(.system(size: 16))
                HStack {
                    ForEach(TuningPreset.standard.notes) { tuningNote in
                        Text(noteName(tuningNote: tuningNote))
                            .font(.system(size: 12))
                            .padding(.all, 4)
                            .background {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.gray)
                            }
                    }
                }
            }
            Spacer()
            if isSelected {
                Image(systemName: "checkmark.circle")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(isSelected ? .blue : .gray)
            }
        }
    }
    
    private func noteName(tuningNote: TuningNote) -> String {
        return "\(tuningNote.note.name())\(tuningNote.octave)"
    }
}

#Preview {
    SettingsScreen(tuningManager: TuningManager())
}
