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
        ZStack {
            Grid()
            VStack {
                HStack {
                    Text(TuningUtils.flatSymbol)
                        .font(.system(size: 36))
                    Spacer()
                    Text(TuningUtils.sharpSymbol)
                        .font(.system(size: 36))
                }
                .padding()
                Spacer()
            }
        }
        .sheet(isPresented: $showSheet) {
            MainContent()
        }
    }
}

private struct MainContent: View {
    
    @EnvironmentObject var tuningManager: TuningManager
    @State var useSharps = false
    
    var body: some View {
        VStack {
            Spacer()
            Text(tuningManager.data.noteName(useSharps: useSharps))
                .font(.system(size: 96))
            + Text("\(tuningManager.data.ocatave)")
                .font(.system(size: 48))
                .baselineOffset(36)
            
            Text("Frequency: \(Int(tuningManager.data.pitch)) Hz")
                .font(.system(size: 24))
            Text("Distance: \(tuningManager.data.distance)")
                .font(.system(size: 16))
            Spacer()
            HStack {
                Spacer()
                Toggle(isOn: $useSharps) {
                    Text("\(TuningUtils.flatSymbol)/\(TuningUtils.sharpSymbol)")
                }
            }
            .padding()
        }
        .presentationDetents([.medium])
        .presentationBackgroundInteraction(.enabled)
    }
}

#Preview {
    Tuner()
        .environmentObject(TuningManager())
}
