//
//  ChromaticTunerView.swift
//  TunApp
//
//  Created by Yassin Mziya on 1/20/25.
//

import SwiftUI

struct ChromaticTunerView: View {
    
    @StateObject var viewModel: ChromaticTunerViewModel
    @State private var meterAngle: Double = 0
    
    init(tuningManager: TuningManager) {
        _viewModel = StateObject(
            wrappedValue: ChromaticTunerViewModel(tuningManager: tuningManager)
        )
    }
    
    var body: some View {
        ZStack {
            VStack {
                Text("TunApp")
                    .padding(EdgeInsets(top: 24, leading: 0, bottom: 0, trailing: 0))
                    .font(.system(size: 24, weight: .bold))
                Spacer()
            }
            VStack {
                Spacer()
                HStack(spacing: 24) {
                    Text("A♭")
                        .font(.system(size: 96))
                        .foregroundColor(.gray)
                    Spacer()
                    Text("A")
                        .font(.system(size: 96))
                    Spacer()
                    Text("B♭")
                        .font(.system(size: 96))
                        .foregroundColor(.gray)
                }
                .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                
                // TODO: Placeholder for linear meter
                LinearMeter()
                    .frame(maxWidth: .infinity, maxHeight: 184)
                
                Text("440 Hz")
                    .padding(EdgeInsets(top: 40, leading: 0, bottom: 0, trailing: 0))
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    ChromaticTunerView(tuningManager: TuningManager())
}
