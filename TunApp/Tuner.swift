//
//  Tuner.swift
//  TunApp
//
//  Created by Yassin Mziya on 10/13/25.
//

import SwiftUI

struct Tuner: View {
    
    @State var showSheet = true
    @EnvironmentObject var tuningManager: TuningManager
    
    var body: some View {
        VStack {
            HStack {
                Text(TuningUtils.flatSymbol)
                    .font(.system(size: 36))
                Spacer()
                Text(TuningUtils.sharpSymbol)
                    .font(.system(size: 36))
            }
            .padding()
            Grid()
        }
        .sheet(isPresented: $showSheet) {
            MainContent()
        }
    }
}

private struct MainContent: View {
    
    @EnvironmentObject var tuningManager: TuningManager
    
    var body: some View {
        VStack {
            Spacer()
            Text(tuningManager.data.noteName())
                .font(.system(size: 96))
            + Text("\(tuningManager.data.ocatave)")
                .font(.system(size: 48))
                .baselineOffset(36)
            Spacer()
        }
        .presentationDetents([.medium])
        .presentationBackgroundInteraction(.enabled)
    }
}

#Preview {
    Tuner()
        .environmentObject(TuningManager())
}
