//
//  GaugeDial.swift
//  TunApp
//
//  Created by Yassin Mziya on 1/26/25.
//

import Foundation
import SwiftUI

struct GaugeDial: Shape {
    
    private(set) var numOfTicks = 9
    private(set) var sweepAngle =  Angle(degrees: 135)
    
    func path(in rect: CGRect) -> Path {
        let radius = rect.width / 2.0
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        // Defaults to i = 0 at 3 o'clock position, drawing clockwise
        // Offset by 180 degrees to flip to 9 o'clock, and additional
        // offset to center dial about 12 o'clock
        let offset: Double = 180
        + (180.0 / Double(numOfTicks)) * 0.5
        
        var path = Path()
        for i in 0..<numOfTicks {
            let degrees = offset
            + (180.0 / Double(numOfTicks)) * Double(i)
            let angle = Angle(degrees: degrees)
            
            // Calculate start piont on circumfrence
            let startPoint = CGPoint(
                x: radius, // * cos(angle.radians) + center.x,
                y: radius // * sin(angle.radians) + center.y
            )
            
            // Calculate direction vector
            let dx = center.x - startPoint.x
            let dy = center.y - startPoint.y
            let distance = sqrt(dx * dx + dy * dy)
            
            // Normalize the vector and scale it to the desired length
            let tickLength = i == numOfTicks/2 || i == 0 ? 24.0 : 12.0
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
    GaugeDial(numOfTicks: 6)
        .stroke(.cyan, style: StrokeStyle(lineWidth: 2.0, lineCap: .round))
        .frame(width: 300, height: 200)
}
