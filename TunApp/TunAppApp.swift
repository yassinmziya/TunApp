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
                .onAppear() {
                    tuniningManager.resume()
                }
                .onChange(of: scenePhase) { _, newPhase in
                    switch newPhase {
                    case .active:
                        if !tuniningManager.engine.avEngine.isRunning {
                            tuniningManager.resume()
                        }
                    case .background, .inactive:
                        tuniningManager.pause()
                    default:
                        break
                    }
                }
        }
    }
    
}
