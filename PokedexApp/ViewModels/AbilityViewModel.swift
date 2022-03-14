//
//  AbilityViewModel.swift
//  PokedexApp
//
//  Created by Giovanni Prestigiacomo on 13/03/22.
//

import Foundation
import PokemonAPI

class AbilityViewModel {
    
    private var abilityNames: [String]
    public var abilities: [Ability] = []
    
    var retrievedAbility: ((Bool) -> ())?

    
    init(abilities: [String]) {
        self.abilityNames = abilities
    }
    
    public func retrieveAbilities() {
        if abilities.isEmpty {
            abilities = []
            if abilityNames.isEmpty {
                self.abilities.append(Ability(name: "This Pokémon has no abilities", description: nil))
            } else {
                abilityNames.forEach() { abilityName in
                    PokedexApp.shared.service.pokemonService.fetchAbility(abilityName) { result in
                        switch result {
                        case .success(let ability):
                            let abilityObject = Ability(name: ability.name ?? "",
                                                        description: self.getEffectDescription(from: ability.effectEntries))
                            self.abilities.append(abilityObject)
                            self.retrievedAbility?(true)
                        case .failure(_):
                            self.abilities.append(Ability(name: "Something went wrong", description: nil))
                            self.retrievedAbility?(false)
                        }
                    }
                }
            }
        } else {
            self.retrievedAbility?(false)
        }

    }
    
    public func getEffectDescription(from effects: [PKMVerboseEffect]?) -> String {
        guard let effects = effects else {
            return ""
        }
        
        var description: String = ""
        
        effects.forEach() { effect in
            if effect.language?.name == "en", let effectDescription = effect.effect {
                description += effectDescription
            }
        }

        return description
    }
}
