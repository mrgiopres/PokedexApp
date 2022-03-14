//
//  PokemonDetailViewModel.swift
//  PokedexApp
//
//  Created by Giovanni Prestigiacomo on 12/03/22.
//

import Foundation
import PokemonAPI

class PokemonDetailViewModel {
    
    public var pokemon: Pokemon?
    
    var retrievedPokemon: ((Bool) -> ())?
    var pokemonName: String
    
    init(pokemonName: String) {
        self.pokemonName = pokemonName
    }
    
    public func retrieve(pokemon name: String) {
        PokedexApp.shared.service.pokemonService.fetchPokemon(name, completion: { pokemonResult in
            switch pokemonResult {
            case .success(let pokemon):
                print("fetchPokemonSuccess\n")
                PokedexApp.shared.service.pokemonService.fetchPokemonSpecies(name, completion: { specieResult in
                    switch specieResult {
                    case .success(let pokemonSpecie):
                        let pokemonObject = Pokemon(url: "", name: pokemon.name ?? "")
                        pokemonObject.id = "\(String(describing: pokemon.id ?? -1))"
                        pokemonObject.frontImageURL = pokemon.sprites?.frontDefault
                        pokemonObject.backImageURL = pokemon.sprites?.backDefault
                        pokemonObject.height = pokemon.height
                        pokemonObject.weight = pokemon.weight
                        pokemonObject.type = HomePageViewModel.getTypes(from: pokemon.types)
                        pokemonObject.stats = self.getStats(from: pokemon)
                        pokemonObject.baseExperience = pokemon.baseExperience
                        pokemonObject.captureRate = pokemonSpecie.captureRate
                        pokemonObject.isBaby = pokemonSpecie.isBaby
                        pokemonObject.happiness = pokemonSpecie.baseHappiness
                        pokemonObject.abilities = self.getAbilities(from: pokemon.abilities)
                        
                        if let frontImage = Pokemon.getImageFromUrl(urlString: pokemonObject.frontImageURL ?? ""),
                           let backImage = Pokemon.getImageFromUrl(urlString: pokemonObject.backImageURL ?? ""),
                           let highQualityImage = Pokemon.getHighQualityImage(for: pokemonObject.id ?? "-1") {
                            pokemonObject.frontImage = frontImage
                            pokemonObject.backImage = backImage
                            pokemonObject.highQualityImage = highQualityImage
                        }
                        
                        self.pokemon = pokemonObject
                        self.retrievedPokemon?(true)
                        print("fetchPokemonSpecieSuccess\n")
                    case .failure(_):
                        self.retrievedPokemon?(false)
                        print("fetchPokemonSpecieFailure \(name)\n")

                    }
                })
            case .failure(_):
                self.retrievedPokemon?(false)
                print("fetchPokemonFailure \(name)\n")
            }
            
        })
    }
    
    public func getStats(from pokemon: PKMPokemon) -> [Stat] {
        guard let stats = pokemon.stats else {
            return []
        }
        
        var statistics: [Stat] = []
        
        stats.forEach() { stat in
            if let name = stat.stat?.name,
               let baseStat = stat.baseStat,
               let effort = stat.effort {
                statistics.append(Stat(name: name, baseStat: baseStat, effort: effort))
            }
        }
        return statistics
    }
    
    public func getAbilities(from abilities: [PKMPokemonAbility]?) -> [String] {
        guard let abilities = abilities else {
            return []
        }
        
        var abilityEntries: [String] = []
        
        abilities.forEach() { ability in
            if let name = ability.ability?.name {
                abilityEntries.append(name)
            }
        }

        return abilityEntries
    }
}
