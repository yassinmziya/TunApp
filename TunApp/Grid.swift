//
//  Grid.swift
//  TunApp
//
//  Created by Yassin Mziya on 10/13/25.
//

import SwiftUI

// MARK: - Grid

struct Grid: View {
    
    @Environment(TuningManager.self) var tuningManager
    
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
    private let strokeColor = Color.gray.opacity(0.25)
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

private let NEEDLE_DIAMETER: CGFloat = 40
private let NEEDLE_POINTER_HEIGHT: CGFloat = 10
private let NEEDLE_TOP_OFFSET: CGFloat = 32

private struct TickerLayer: View {
    
    private let SPEED: CGFloat = 32.0
    private let TICK_HEIGHT: CGFloat = 4.0
    private let TICK_WIDTH: CGFloat = 3.0
    
    @State var valueBuffer = ValueBuffer()
    @Environment(TuningManager.self) var tuningManager
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                valueBuffer.values.forEach { (timeStamp, pitch) in
                    var path = Path()
                    let xOffset = size.width / 2.0
                    let x = xOffset + CGFloat.boundedValue(pitch, availableWidth: size.width)
                    let elapsed = timeline.date.timeIntervalSince(timeStamp)
                    let yOffset = NEEDLE_DIAMETER + NEEDLE_POINTER_HEIGHT + NEEDLE_TOP_OFFSET
                    let y = yOffset + SPEED * elapsed
                    path.addRect(CGRect(
                        origin: CGPoint(x: x, y: y),
                        size: CGSize(
                            width: TICK_WIDTH, height: TICK_HEIGHT)
                    ))
                    context.fill(path, with: .color(.red))
                }
            }
        }
        .onChange(of: tuningManager.tuningData) { _, tuningData in
            guard let tuningData else { return }
            valueBuffer.add(CGFloat(tuningData.distance))
        }
    }
}


// MARK: - CenterRulingLayer

private struct NeedleLayer: View {
    
    @Environment(TuningManager.self) var tuningManager
    
    var tuningData: TuningData? {
        return tuningManager.tuningData
    }
    
    var strokeColor: Color {
        guard let tuningData else {
            return .white
        }
        
        return tuningData.distance < 0.02 ? .green : .red
    }
    
    var needleText: String {
        guard let tuningData else {
            return ""
        }
        return "\(Int(tuningData.distance))"
    }
    
    func getXValue(availableWidth: CGFloat) -> CGFloat {
        guard let tuningData else {
            return .zero
        }
        return CGFloat.boundedValue(
            CGFloat(tuningData.distance),
            availableWidth: availableWidth)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Center rule
                Path { path in
                    let x = geometry.size.width / 2.0
                    path.move(to: .init(x: x, y: 0))
                    path.addLine(to: .init(x: x, y: geometry.size.height))
                }
                .stroke(Color.gray, lineWidth: 1.2)
                
                // Needle
                let xValue = getXValue(availableWidth: geometry.size.width)
                VStack(alignment: .center, spacing: 0) {
 
                    Text(needleText)
                        .font(.system(size: 12))
                        .frame(width: NEEDLE_DIAMETER, height: NEEDLE_DIAMETER)
                        .overlay {
                            Circle()
                                .stroke(strokeColor, lineWidth: 4)
                        }
                        .background(.background)
                        .offset(x: xValue)
                        .animation(.spring, value: xValue)
                        .contentTransition(.identity)
                    
                    Triangle()
                        .fill(strokeColor)
                        .stroke(strokeColor, style: StrokeStyle(lineWidth: 0.1, lineJoin: .round))
                        .frame(width: 8, height: NEEDLE_POINTER_HEIGHT)
                        .offset(x: xValue)
                        .animation(.spring, value: xValue)
                    Spacer()
                }
                .padding(.top, NEEDLE_TOP_OFFSET)
            }
        }
    }
    
    struct Triangle: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.closeSubpath()
            return path
        }
    }
}

@Observable
fileprivate class ValueBuffer {
    
    private let limit = 3000
    private(set)var values = [(Date, CGFloat)]()
    
    func add(_ value: CGFloat) {
        if (values.count == limit) {
            _ = values.removeLast()
        }
        values.insert((Date.now, value), at: 0)
    }
}

fileprivate extension CGFloat {
    
    static func boundedValue(_ value: CGFloat, availableWidth: CGFloat) -> CGFloat {
        let limitedValue = Swift.max(Swift.min(100, value), -100) // limit raw cent value so that needle doesn't fly off screen
        let padding = 64.0
        return ((availableWidth - padding) * limitedValue / 200.0).rounded()
    }
}

#Preview {
    Grid()
        .environment(TuningManager())
}
