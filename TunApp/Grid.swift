//
//  Grid.swift
//  TunApp
//
//  Created by Yassin Mziya on 10/13/25.
//

import SwiftUI

struct Grid: View {
    
    private let speed: CGFloat = 32
    
    @State private var startDate = Date()

    var body: some View {
        TimelineView(.animation) { timeline in
            ZStack {
                Canvas { context, size in
                    let spacing: CGFloat = size.width/18.0
                    let elapsed = timeline.date.timeIntervalSince(startDate)
                    let rawOffset = elapsed * speed
                    let offset = rawOffset.truncatingRemainder(dividingBy: spacing)
                    
                    let numberOfHorizontalLines = size.height / spacing
                    for i in 0...Int(numberOfHorizontalLines) {
                        var path = Path()
                        let y = (CGFloat(i) * spacing) - offset
                        path.move(to: .init(x: .zero, y: y))
                        path.addLine(to: .init(x: size.width, y: y))
                        context.stroke(path, with: .color(.gray.opacity(0.2)), lineWidth: 1)
                    }
                    let numberOfVerticalLines = size.width / spacing
                    for i in 0...Int(numberOfVerticalLines) {
                        var path = Path()
                        let x = (CGFloat(i) * spacing)
                        path.move(to: .init(x: x, y: .zero))
                        path.addLine(to: .init(x: x, y: size.height))
                        context.stroke(path, with: .color(.gray.opacity(0.2)), lineWidth: 1)
                    }
                }
                .mask(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .clear, location: 0.0),
                            .init(color: .black, location: 0.2),
                            .init(color: .black, location: 0.6),
                            .init(color: .clear, location: 1.0),
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
        }
    }
}

#Preview {
    Grid()
}
