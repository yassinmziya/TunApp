//
//  Grid.swift
//  TunApp
//
//  Created by Yassin Mziya on 10/13/25.
//

import SwiftUI

// MARK: - Grid

struct Grid: View {
    
    @EnvironmentObject var tuningManager: TuningManager
    
    var body: some View {
        ZStack {
            GridLinesLayer()
                .gradientMask()
            TickerLayer()
            NeedleLayer()
        }
    }
}

fileprivate extension View {
    
    func gradientMask() -> some View {
        self.mask(
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: .clear, location: 0.0),
                    .init(color: .black, location: 0.1),
                    .init(color: .black, location: 0.9),
                    .init(color: .clear, location: 1.0),
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

// MARK: - GridLinesLayer

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
                        let y = (CGFloat(i) * spacing) + offset
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

// MARK: - TickerLayer

private struct TickerLayer: View {
    
    private let speed: CGFloat = 32
    
    @StateObject var valueBuffer = ValueBuffer()
    @EnvironmentObject var tuningManager: TuningManager
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                for value in valueBuffer.values {
                    var path = Path()
                    let x = size.width / 2.0 + value.1
                    let elapsed = timeline.date.timeIntervalSince(value.0)
                    let y = 64 + speed * elapsed
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
        .onReceive(tuningManager.$data) { tuningData in

            valueBuffer.add(tuningData.boundedValue)
        }
    }
}


// MARK: - CenterRulingLayer

private struct NeedleLayer: View {
    
    @EnvironmentObject var tuningManager: TuningManager
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Path { path in
                    let x = geometry.size.width / 2.0
                    path.move(to: .init(x: x, y: 0))
                    path.addLine(to: .init(x: x, y: geometry.size.height))
                }
                .stroke(Color.gray, lineWidth: 1.2)
                Canvas { context, size in
                    var path = Path()
                    let height: CGFloat = 32.0
                    let x = size.width / 2.0 + tuningManager.data.boundedValue - height/2.0
                    path.addEllipse(
                        in: CGRect(
                            origin: CGPoint(x: x, y: height),
                            size: CGSize(width: height, height: height)
                        )
                    )
                    context.fill(path, with: .color(.black))
                    context.stroke(path, with: .color(.green), lineWidth: 2)
                }
            }
        }
    }
}

fileprivate class ValueBuffer: ObservableObject {
    
    private let limit = 3000
    @Published private(set)var values = [(Date, CGFloat)]()
    
    func add(_ value: CGFloat) {
        if (values.count == limit) {
            _ = values.removeLast()
        }
        values.insert((Date.now, value), at: 0)
    }
}

fileprivate extension TuningData {
    
    var boundedValue: CGFloat {
        let scaledValue = CGFloat(distance) * 250
        return min(max(scaledValue, -150), 150)
    }
}

#Preview {
    Grid()
        .environmentObject(TuningManager())
}
