//
//  Grid.swift
//  TunApp
//
//  Created by Yassin Mziya on 10/13/25.
//

import SwiftUI

struct Grid: View {
    
    var body: some View {
        ZStack {
            GridLinesLayer()
            TicksLayer()
        }
        .gradientMask()
    }
}

struct GridLinesLayer: View {
    
    private let strokeWidth: CGFloat = 1.0
    private let strokeColor = Color.gray.opacity(0.1)
    private let numberOfSquaresAccrossWidth = 18.0
    private let speed: CGFloat = 32
    
    @State private var startDate = Date()

    var body: some View {
        TimelineView(.animation) { timeline in
            ZStack {
                Canvas { context, size in
                    let spacing: CGFloat = size.width/numberOfSquaresAccrossWidth
                    let elapsed = timeline.date.timeIntervalSince(startDate)
                    let rawOffset = elapsed * speed
                    let offset = rawOffset.truncatingRemainder(dividingBy: spacing)
                    
                    let numberOfHorizontalLines = size.height / spacing
                    for i in 0...Int(numberOfHorizontalLines) {
                        var path = Path()
                        let y = (CGFloat(i) * spacing) - offset
                        path.move(to: .init(x: .zero, y: y))
                        path.addLine(to: .init(x: size.width, y: y))
                        context.stroke(path, with: .color(strokeColor), lineWidth: strokeWidth)
                    }
                    let numberOfVerticalLines = size.width / spacing
                    for i in 0...Int(numberOfVerticalLines) {
                        var path = Path()
                        let x = (CGFloat(i) * spacing)
                        path.move(to: .init(x: x, y: .zero))
                        path.addLine(to: .init(x: x, y: size.height))
                        context.stroke(path, with: .color(strokeColor), lineWidth: strokeWidth)
                    }
                }
                .gradientMask()
            }
        }
    }
}

private struct TicksLayer: View {
    
    private let speed: CGFloat = 0.5
    @State private var startDate = Date()
    @StateObject var valueBuffer = ValueBuffer()
    
    @State var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                var path = Path()
                let x = size.width / 2.0
                path.move(to: .init(x: x, y: 0))
                path.addLine(to: .init(x: x, y: size.height))
                context.stroke(path, with: .color(.red), lineWidth: 1.2)
                
                for (index, value) in valueBuffer.values.enumerated() {
                    var path = Path()
                    let x = size.width / 2.0 + value
                    let y =  size.height / 2.0  - CGFloat(index) * speed
                    path.addEllipse(
                        in: CGRect(
                            origin: CGPoint(x: x, y: y),
                            size: CGSize(width: 4, height: 4)
                        )
                    )
                    context.fill(path, with: .color(.red))
                }
            }
        }
        .onReceive(timer) { _ in
            valueBuffer.add(.random(in: -1000...1000))
//            valueBuffer.add(167)
        }
    }
}

fileprivate class ValueBuffer: ObservableObject {
    
    private let limit = 1000
    @Published private(set)var values = [CGFloat]()
    
    func add(_ value: CGFloat) {
        if (values.count == limit) {
            _ = values.removeLast()
        }
        values.insert(value, at: 0)
    }
}

fileprivate extension View {
    
    func gradientMask() -> some View {
        self.mask(
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: .clear, location: 0.0),
                    .init(color: .black, location: 0.05),
                    .init(color: .black, location: 0.95),
                    .init(color: .clear, location: 1.0),
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

#Preview {
    Grid()
}
