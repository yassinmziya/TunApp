//
//  TunAppApp.swift
//  TunApp
//
//  Created by Yassin Mziya on 1/18/25.
//

import SwiftUI

@main
struct TunAppApp: App {
    
    @Environment(\.scenePhase) private var scenePhase
    private let tuniningManager = TuningManager()
    
    var body: some Scene {
        WindowGroup {
            ChromaticTunerView(tuningManager: tuniningManager)
                .onChange(of: scenePhase) { phase in
                    switch phase {
                    case .active:
                        tuniningManager.start()
                    case .background, .inactive:
                        tuniningManager.stop()
                    default:
                        tuniningManager.stop()
                    }
                }
        }
    }
    
}
