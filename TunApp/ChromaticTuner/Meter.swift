//
//  Meter.swift
//  TunApp
//
//  Created by Yassin Mziya on 1/25/25.
//

import SwiftUI

struct Meter: View {
    
    let angle: Double
    
    var body: some View {
        VStack {
            ZStack() {
                Color(.systemCyan)
                    .frame(width: 4, height: 150)
            }
            .rotationEffect(.degrees(max(min(90, angle), -90)), anchor: .bottom)
        }
    }
}

#Preview {
    Meter(angle: -12)
}
