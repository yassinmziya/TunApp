//
//  ChromaticTunerView.swift
//  TunApp
//
//  Created by Yassin Mziya on 1/20/25.
//

import SwiftUI

struct ChromaticTunerView: View {
    
    @StateObject var viewModel: ChromaticTunerViewModel
    
    init(tuningManager: TuningManager) {
        _viewModel = StateObject(
            wrappedValue: ChromaticTunerViewModel(tuningManager: tuningManager)
        )
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(viewModel.viewData.prevNoteName)
                Text(viewModel.viewData.noteName)
                    .font(.system(size: 48))
                Text(viewModel.viewData.nextNoteName)
                
            }
            Text(viewModel.viewData.frequency)
        }
    }
}

#Preview {
    ChromaticTunerView(tuningManager: TuningManager())
}
