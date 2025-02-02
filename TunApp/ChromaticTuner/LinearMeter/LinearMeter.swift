//
//  LinearMeter.swift
//  TunApp
//
//  Created by Yassin Mziya on 2/1/25.
//

import SwiftUI

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        }
    }
}

struct LinearMeter: View {
    
    private let numberOfTicks: CGFloat = 29
    private let tickHeight: CGFloat = 85.63
    private let largeTickHeight: CGFloat = 128.44
    private let tickWidth: CGFloat = 4
    
    var body: some View {
        GeometryReader { geometry in
            Triangle()
                .frame(width: 24, height: 12)
                .rotationEffect(.degrees(180))
                .position(CGPoint(x: geometry.size.width/2, y: 6))
                .foregroundColor(Color.gray)
            
            Canvas { context, size in
                let spacing = (geometry.size.width - numberOfTicks * tickWidth)
                / (numberOfTicks - 1)
                
                var xOffset = tickWidth / 2.0
                (1...Int(numberOfTicks)).forEach { index in
                    let tickHeight  = index % 5 == 0 ? self.largeTickHeight : self.tickHeight
                    let yOffset = (geometry.size.height - tickHeight) / 2.0
                    
                    _ = Path { path in
                        let startPoint = CGPoint(x: xOffset, y: yOffset)
                        let endPoint = CGPoint(x: xOffset, y: yOffset + tickHeight)
                        path.move(to: endPoint)
                        path.addLine(to: startPoint)
                        context.stroke(path, with: .color(.gray), lineWidth: tickWidth)
                    }
                    xOffset += spacing + tickWidth
                }
                
            }
            
            Triangle()
                .frame(width: 24, height: 12)
                .position(CGPoint(x: geometry.size.width/2, y: geometry.size.height - 6))
                .foregroundColor(Color.gray)
        }
    }
}

#Preview {
    LinearMeter()
        .frame(width: .infinity, height: 184)
}
