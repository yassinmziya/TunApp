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
            Tuner()
        }
    }
    
}
