//
//  SettingsScreen.swift
//  TunApp
//
//  Created by Yassin Mziya on 12/20/25.
//

import SwiftUI

struct SettingsScreen: View {
    
    @Environment(TuningManager.self) var tuningManager
    @State private var selectedInstrument: Instrument = .acousticGuitar
    
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
                                selectedInstrument = instrument
                                switch instrument {
                                case .chromatic:
                                    tuningManager.tuningPreset = nil
                                    tuningManager.tuningNote = nil
                                default:
                                    tuningManager.tuningPreset = .standard
                                    tuningManager.tuningNote = TuningPreset.standard.notes.first
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                }
                .scrollClipDisabled(true)
                
                VStack(spacing: 12) {
                    ForEach(selectedInstrument.tuningPresets) { tuningPreset in
                        let isSelected = tuningPreset == tuningManager.tuningPreset
                        TuningPresetRow(
                            tuningPreset: tuningPreset,
                            isSelected: isSelected)
                        Divider()
                            .frame(height: 2)
                            .overlay(isSelected ? .blue : .gray)
                    }
                }
                Spacer()
            }
        }
        // @maxime Nice!
        .scrollClipDisabled(true)
        .padding()
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
                        .inset(by: 2)
                        .stroke(style: .init(lineWidth: 4))
                    
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
    
    @Environment(TuningManager.self) var tuningManager
    
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
                    .frame(width: 24, height: .infinity)
                    .foregroundColor(isSelected ? .blue : .gray)
            }
        }
        .onTapGesture {
            didSelectTuningPreset(tuningPresent: tuningPreset)
        }
    }
    
    private func noteName(tuningNote: TuningNote) -> String {
        return "\(tuningNote.note.name())\(tuningNote.octave)"
    }
    
    private func didSelectTuningPreset(tuningPresent: TuningPreset) {
        tuningManager.tuningPreset = tuningPresent
    }
}

#Preview {
    SettingsScreen()
        .environment(TuningManager())
}
