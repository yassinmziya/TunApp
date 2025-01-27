//
//  MeterDial.swift
//  TunApp
//
//  Created by Yassin Mziya on 1/26/25.
//

import Foundation
import SwiftUI

struct MeterDial: Shape {
    
    private let totalTicks = 4
    
    func path(in rect: CGRect) -> Path {
        let radius = rect.height / 2
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let tickLength = 12.0
        var path = Path()
        
        for i in 1...totalTicks {
            let angle = Angle(
                degrees: (-180.0 / Double(totalTicks + 1)) * Double(i)
            )
            let startPoint = CGPoint(
                x: radius * cos(angle.radians) + center.x,
                y: radius * sin(angle.radians) + center.y
            )
            
            // Calculate direction vector
            let dx = startPoint.x - center.x
            let dy = startPoint.y - center.y
            let distance = sqrt(dx * dx + dy * dy)
            
            // Normalize the vector and scale it to the desired length
            let scale = tickLength / distance
            let endPoint = CGPoint(
                x: startPoint.x + dx * scale,
                y: startPoint.y + dy * scale
            )
            
            path.move(to: startPoint)
            path.addLine(to: endPoint)
        }
        
        return path
    }
}

#Preview {
    MeterDial()
        .stroke(.cyan, style: StrokeStyle(lineWidth: 2.0, lineCap: .round))
        .frame(width: 500, height: 200)
}
