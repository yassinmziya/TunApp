//
//  Meter.swift
//  TunApp
//
//  Created by Yassin Mziya on 1/25/25.
//

import SwiftUI

struct Meter: View {
    
    private let MAX_ANGLE = 72.0
    let angle: Double
    
    var body: some View {
        VStack {
            ZStack() {
                MeterDial()
                    .stroke(.cyan, style: StrokeStyle(lineWidth: 2.0, lineCap: .round))
                    .frame(height: 200)
                Color(.systemCyan)
                    .frame(width: 4, height: 150)
                    .rotationEffect(
                        .degrees(max(min(MAX_ANGLE, angle), -MAX_ANGLE)),
                        anchor: .bottom
                    )
            }
        }
    }
}

#Preview {
    Meter(angle: -90)
}
