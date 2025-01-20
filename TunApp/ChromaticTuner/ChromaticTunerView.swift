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
        Text(viewModel.viewData.frequency)
            .font(.system(size: 48))
    }
}

#Preview {
    ChromaticTunerView(tuningManager: TuningManager())
}
