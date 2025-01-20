//
//  ChromaticTunerViewModel.swift
//  TunApp
//
//  Created by Yassin Mziya on 1/20/25.
//

import Combine
import SwiftUI

class ChromaticTunerViewModel: ObservableObject {
    
    @Published var viewData = ChromaticTunerViewData(
        frequency: "-"
    )
    
    private let tuningManager: TuningManager
    private var cancellables = Set<AnyCancellable>()
    private var transformer = ChromaticTunerTransformer()
    
    init(tuningManager: TuningManager) {
        self.tuningManager = tuningManager
        
        tuningManager.$data
            .sink { [weak self] tuningData in
                guard let self else {
                    return
                }
                self.viewData = self.transformer.transform(tuningData)
            }
            .store(in: &cancellables)
    }
}
