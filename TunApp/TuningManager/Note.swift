//
//  Note.swift
//  TunApp
//
//  Created by Yassin Mziya on 12/15/25.
//

/**
 Represents a note within the reference window
 */
enum Note: CaseIterable {
    
    case c
    case cSharp
    case d
    case dSharp
    case e
    case f
    case fSharp
    case g
    case gSharp
    case a
    case aSharp
    case b
    
    func name(usingFlats: Bool = true) -> String {
        switch self {
        case .c:      return "C"
        case .cSharp: return usingFlats ? "D♭" : "C♯"
        case .d:      return "D"
        case .dSharp: return usingFlats ? "E♭" : "D♯"
        case .e:      return "E"
        case .f:      return "F"
        case .fSharp: return usingFlats ? "G♭" : "F♯"
        case .g:      return "G"
        case .gSharp: return usingFlats ? "A♭" : "G♯"
        case .a:      return "A"
        case .aSharp: return usingFlats ? "B♭" : "A♯"
        case .b:      return "B"
        }
    }
    
    var referenceFrequency: Float {
        switch self {
        case .c: return 16.3516
        case .cSharp: return 17.3239
        case .d: return 18.3540
        case .dSharp: return 19.4454
        case .e: return 20.6017
        case .f: return 21.8268
        case .fSharp: return 23.1247
        case .g: return 24.4997
        case .gSharp: return 25.9565
        case .a: return 27.5000
        case .aSharp: return 29.1352
        case .b: return 30.8677
        }
    }
}
