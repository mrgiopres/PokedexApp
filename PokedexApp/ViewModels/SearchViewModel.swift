//
//  SearchViewModel.swift
//  PokedexApp
//
//  Created by Giovanni Prestigiacomo on 13/03/22.
//

import Foundation

class SearchViewModel: HomePageViewModel {
    public var searchedItems: [Pokemon] = []
    
    var retrievedSearchItems: ((Bool) -> ())?
    
    init(homePageViewModel: HomePageViewModel) {
        super.init(pokemonsPerPage: 15)
        self.pokemonPages = homePageViewModel.pokemonPages
        self.relevantPokemons = homePageViewModel.relevantPokemons
    }
    
    public func search(pokemon name: String) {
        self.searchedItems = []
        var found: Bool = false
        self.pokemonPages.forEach() { page in
            page.pokemons.forEach() { pokemon in
                if pokemon.name.lowercased().contains(name.lowercased()) {
                    found = true
                    searchedItems.append(pokemon)
                }
            }
        }
        
        if !found {
            self.relevantPokemons.forEach() { pokemon in
                if pokemon.name.lowercased().contains(name.lowercased()) {
                    found = true
                    searchedItems.append(pokemon)
                }
            }
        }
        
        if !found {
            PokedexApp.shared.service.pokemonService.fetchPokemon(name, completion: { result in
                switch result {
                case .success(let pokemon):
                    if let name = pokemon.name {
                        self.searchedItems.append(Pokemon(url: "", name: name))
                        found = true
                        self.retrievedSearchItems?(found)

                    } else {
                        found = false
                    }
                case .failure(_):
                    found = false
                }
            })
        }
        
        self.retrievedSearchItems?(found)
    }
    
    public func search(pokemon name: String, by type: String) {
        self.searchedItems = []

        var found: Bool = false
        PokedexApp.shared.service.pokemonService.fetchType(type, completion: { result in
            switch result {
            case .success(let typeObject):
                if let pokemons = typeObject.pokemon {
                    pokemons.forEach() { pokemon in
                        if let pokemonName = pokemon.pokemon?.name {
                            if name != "", pokemonName.lowercased().contains(name.lowercased()) {
                                self.searchedItems.append(Pokemon(url: "", name: pokemonName))
                                found = true
                            } else {
                                self.searchedItems.append(Pokemon(url: "", name: pokemonName))
                            }
                        }
                    }
                }
            case .failure(_):
                found = false
            }
        })
        
        self.retrievedSearchItems?(found)
    }
    
}
