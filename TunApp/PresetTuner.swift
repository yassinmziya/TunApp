//
//  PresetTuner.swift
//  TunApp
//
//  Created by Yassin Mziya on 12/16/25.
//

import SwiftUI

struct PresetTuner: View {
    
    @Environment(TuningManager.self) var tuningManager
    
    let tuningPreset: TuningPreset
    @State private var isAutoDetectionEnabled: Bool
    
    private var pitchText: String {
        if let pitch = tuningManager.tuningData?.pitch {
            return "\(Int(pitch)) Hz"
        }
        return ""
    }
    
    init(tuningPreset: TuningPreset, isAutoDetectionEnabled: Bool) {
        self.tuningPreset = tuningPreset
        self.isAutoDetectionEnabled = isAutoDetectionEnabled
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            HStack {
                ForEach(tuningPreset.pitches.indices, id: \.self) { index in
                    let pitch = tuningPreset.pitches[index]
                    HeadstockButton(
                        pitch: pitch,
                        isActive: pitch == tuningManager.selectedPitch
                    ) {
                        tuningManager.updateSelectedPitch(pitch)
                    }
                    if index < tuningPreset.pitches.count - 1 {
                        Spacer()
                    }
                }
            }
            .padding(.horizontal)
            
            Text(pitchText)
                .font(.system(size: 24))
                .foregroundStyle(.chromeJack)
            
            Spacer()
            
            HStack {
                Spacer()
                Toggle(isOn: $isAutoDetectionEnabled) {
                    Text("Auto")
                }
                .fixedSize()
                .padding()
                .tint(.accent)
                .onChange(of: isAutoDetectionEnabled) { _, newValue in
                    tuningManager.toggleAutoDetection(newValue)
                }
            }
        }
    }
}

// MARK: - HeadstockButton

fileprivate struct HeadstockButton: View {
    
    let pitch: Pitch
    let isActive: Bool
    let action: () -> Void
    
    private let radius: CGFloat = 56
    
    var body: some View {
        Group {
            Text(pitch.pitchClass.name())
                .font(.system(size: 24))
            + Text("\(pitch.octave)")
                .font(.system(size: 16))
        }
        .frame(width: radius, height: radius)
        .overlay {
            Circle()
                .stroke(
                    .border,
                    lineWidth: 1
                )
        }
        .glassEffect(.regular.tint(isActive ? .accent : .clear).interactive())
        .onTapGesture(perform: action)
    }
}

#Preview {
    PresetTuner(tuningPreset: .standard, isAutoDetectionEnabled: true)
        .environment(TuningManager())
}
