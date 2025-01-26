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
        VStack {
            Meter(angle: meterAngle)
            HStack {
                Text(viewModel.viewData.prevNoteName)
                Text(viewModel.viewData.noteName)
                    .font(.system(size: 48))
                Text(viewModel.viewData.nextNoteName)
                
            }
            Text(viewModel.viewData.frequency)
        }
        .onChange(of: viewModel.viewData.distance) { _, newValue in
            withAnimation {
                meterAngle = Double(viewModel.viewData.distance * 90.0)
            }
        }
    }
}

#Preview {
    ChromaticTunerView(tuningManager: TuningManager())
}
