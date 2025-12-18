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
    
    var body: some View {
//        HStack(alignment: .top) {
//            VStack(spacing: 40) {
//                ForEach(tuningPreset.notes.prefix(3).reversed()) { tuningNote in
//                    HeadstockButton(
//                        tuningNote: tuningNote,
//                        isActive: tuningNote == tuningManager.tuningNote
//                    ) {
//                        tuningManager.tuningNote = tuningNote
//                    }
//                }
//            }
//            Spacer()
//            VStack(spacing: 40) {
//                ForEach(tuningPreset.notes.suffix(3)) { tuningNote in
//                    HeadstockButton(
//                        tuningNote: tuningNote,
//                        isActive: tuningNote == tuningManager.tuningNote
//                    ) {
//                        tuningManager.tuningNote = tuningNote
//                    }
//                }
//            }
//        }
        HStack {
            ForEach(tuningPreset.notes.indices, id: \.self) { index in
                let tuningNote = tuningPreset.notes[index]
                HeadstockButton(
                    tuningNote: tuningNote,
                    isActive: tuningNote == tuningManager.tuningNote
                ) {
                    tuningManager.tuningNote = tuningNote
                }
                if index < tuningPreset.notes.count - 1 {
                    Spacer()
                }
            }
        }
        .padding(.horizontal)
    }
}

fileprivate struct HeadstockButton: View {
    
    let tuningNote: TuningNote
    let isActive: Bool
    let action: () -> Void
    
    private let RADIUS: CGFloat = 48
    
    var body: some View {
        Button(action: action) {
            Text(tuningNote.note.name())
                .frame(width: RADIUS, height: RADIUS)
        }
        .clipShape(Circle())
        .glassEffect(.regular.tint(isActive ? .blue : nil))
        .tint(.primary)
        .overlay {
            Circle()
                .stroke(.white, lineWidth: 1)
        }
    }
}

#Preview {
    PresetTuner(tuningPreset: .standard)
        .environment(TuningManager())
}
