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
    
    init(tuningPreset: TuningPreset) {
        self.tuningPreset = tuningPreset
    }
    
    var body: some View {
        HStack {
            ForEach(tuningPreset.pitches.indices, id: \.self) { index in
                let pitch = tuningPreset.pitches[index]
                HeadstockButton(
                    pitch: pitch,
                    isActive: pitch == tuningManager.selectedPitch
                ) {
                    tuningManager.selectedPitch = pitch
                }
                if index < tuningPreset.pitches.count - 1 {
                    Spacer()
                }
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - HeadstockButton

fileprivate struct HeadstockButton: View {
    
    let pitch: Pitch
    let isActive: Bool
    let action: () -> Void
    
    private let RADIUS: CGFloat = 56
    
    var body: some View {
        Button(action: action) {
            Group {
                Text(pitch.pitchClass.name())
                    .font(.system(size: 24))
                + Text("\(pitch.octave)")
                    .font(.system(size: 16))
            }
            .frame(width: RADIUS, height: RADIUS)
        }
        .clipShape(Circle())
        .tint(.primary)
        .overlay {
            Circle()
                .stroke(.white, lineWidth: 1)
        }
        .background {
            Circle()
                .fill(isActive ? Color.accentColor : .clear)
        }
    }
}

#Preview {
    PresetTuner(tuningPreset: .standard)
        .environment(TuningManager())
}
