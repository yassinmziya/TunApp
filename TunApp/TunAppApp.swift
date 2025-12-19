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
    @State var tuniningManager = TuningManager()
    
    var body: some Scene {
        WindowGroup {
            TunerScreen()
                .environment(tuniningManager)
                .onChange(of: scenePhase) { _, newPhase in
                    switch newPhase {
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
