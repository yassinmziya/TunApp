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
    @StateObject var tuniningManager = TuningManager()
    
    var body: some Scene {
        WindowGroup {
            Tuner()
                .environmentObject(tuniningManager)
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
