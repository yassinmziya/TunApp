//
//  ContentView.swift
//  TunApp
//
//  Created by Yassin Mziya on 1/18/25.
//

import SwiftUI

struct ContentView: View {
    
    
    @StateObject var tuningService = TuningService.shared
    
    var body: some View {
        VStack {
            Text("Note Name:")
            HStack {
                Text("\(tuningService.data.prevNoteNameWithFlats)")
                Text("\(tuningService.data.noteNameWithFlats)\(tuningService.data.ocatave)")
                    .font(.system(size: 36))
                Text("\(tuningService.data.nextNoteNameWithFlats)")
            }
            Text("\(tuningService.data.distance)")
            Text("\(trunc(tuningService.data.pitch)) Hz")
        }
        .padding()
        .onAppear {
            tuningService.start()
        }
        .onDisappear {
            tuningService.stop()
        }
    }
}

#Preview {
    ContentView()
}
