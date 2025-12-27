//
//  IconButton.swift
//  TunApp
//
//  Created by Yassin Mziya on 12/24/25.
//

import SwiftUI

struct IconButton: View {
    
    private let radius: CGFloat = 56
    
    enum Style {
        case primary, secondary
    }
    
    let iconImage: Image
    let style: Style
    let action: () -> Void
    
    var body: some View {
        switch style {
        case .primary:
            iconImage
                .frame(width: radius, height: radius)
                .glassEffect(.clear.tint(.accent).interactive())
                .onTapGesture(perform: action)
        case .secondary:
            iconImage
                .frame(width: radius, height: radius)
                .glassEffect(.regular.interactive(), in: .circle)
                .onTapGesture(perform: action)
        }
    }
}

#Preview {
    HStack {
        IconButton(iconImage: Image(systemName: "gearshape.fill"), style: .primary) {}
        IconButton(iconImage: Image(systemName: "gearshape.fill"), style: .secondary) {}
    }
}
