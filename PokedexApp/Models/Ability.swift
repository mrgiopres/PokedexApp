//
//  Ability.swift
//  PokedexApp
//
//  Created by Giovanni Prestigiacomo on 13/03/22.
//

import Foundation

class Ability {
    var name: String
    var description: String?
    
    init(name: String, description: String?) {
        self.name = name
        self.description = description
    }
}
