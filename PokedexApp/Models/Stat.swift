//
//  Stat.swift
//  PokedexApp
//
//  Created by Giovanni Prestigiacomo on 12/03/22.
//

import Foundation
import UIKit

class Stat {
    var baseStat: Int
    var effort: Int
    var name: String
    var type: StatType
    
    init(name: String, baseStat: Int, effort: Int) {
        self.name = name
        self.baseStat = baseStat
        self.effort = effort
        self.type = StatType(rawValue: name) ?? .unknown
    }
    
    enum StatType: String {
        case hp = "hp"
        case attack = "attack"
        case defense = "defense"
        case specialAttack = "special-attack"
        case specialDefense = "special-defense"
        case speed = "speed"
        case accuracy = "accuracy"
        case evasion = "evasion"
        case captureRate = "capture-rate"
        case happiness = "happiness"
        case unknown = "unknown"
        
        func title() -> String {
            switch self {
            case .hp:
                return "Stamina"
            case .attack:
                return "Attack"
            case .defense:
                return "Defense"
            case .specialAttack:
                return "Special attack"
            case .specialDefense:
                return "Special Defense"
            case .speed:
                return "Speed"
            case .accuracy:
                return "Accuracy"
            case .evasion:
                return "Evasion"
            case .captureRate:
                return "Capture rate"
            case .happiness:
                return "Happiness"
            case .unknown:
                return "Unknown"
            }
        }
        
        func color() -> UIColor {
            switch self {
            case .hp:
                return #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            case .attack:
                return #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
            case .defense:
                return #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
            case .specialAttack:
                return #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1)
            case .specialDefense:
                return #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
            case .speed:
                return #colorLiteral(red: 0.8608503938, green: 0.3811115324, blue: 0.8776554465, alpha: 1)
            case .accuracy:
                return #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            case .evasion:
                return #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
            case .happiness:
                return #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1)
            case .captureRate:
                return #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
            default:
                return .lightGray
            }
        }
    }
}
