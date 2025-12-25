//
//  IconButton.swift
//  TunApp
//
//  Created by Yassin Mziya on 12/24/25.
//

import SwiftUI

struct IconButton: View {
    
    enum Style {
        case primary, secondary
    }
    
    let iconImage: Image
    let style: Style
    let action: () -> Void
    
    var body: some View {
        
        Group {
            switch style {
            case .primary:
                Button(action: action) {
                    iconImage
                }
                .buttonStyle(.glassProminent)
            case .secondary:
                Button(action: action) {
                    iconImage
                }
                .buttonStyle(.glass)
            }
        }
        .controlSize(.extraLarge)
        .glassEffect(.regular.interactive(), in: .circle)
        .background {
            Circle()
                .fill(Color.accentColor)
        }
    }
}

#Preview {
    HStack {
        IconButton(iconImage: Image(systemName: "gearshape.fill"), style: .primary) {}
        IconButton(iconImage: Image(systemName: "gearshape.fill"), style: .secondary) {}
    }
}
