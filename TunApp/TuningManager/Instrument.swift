//
//  Instrument.swift
//  TunApp
//
//  Created by Yassin Mziya on 12/22/25.
//

enum Instrument: String, CaseIterable, Identifiable {
    
    var id: String {
        rawValue
    }
    
    case chromatic = "Chromatic"
    case acousticGuitar = "Acoustic Guitar"
    case electricGuitar = "Electric Guitar"
    
    var tuningPresets: [TuningPreset] {
        switch self {
        case .chromatic:
            return []
        case .acousticGuitar, .electricGuitar:
            return [.standard, .dropD, .openG]
        }
    }
}
