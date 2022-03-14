//
//  PokedexManager.swift
//  PokedexApp
//
//  Created by Giovanni Prestigiacomo on 13/03/22.
//

import Foundation
import PokemonAPI

protocol PokedexServiceProvider {
    static func fetchPokemonList<T>(paginationState: PaginationState<T>, completion: @escaping (_ result: Result<PKMPagedObject<T>, Error>) -> Void) where T: PKMPokemon
    static func fetchPokemon(_ pokemonName: String, completion: @escaping (_ result: Result<PKMPokemon, Error>) -> Void)
}

/// Non testable class
class PokedexManager {
    
    var serviceProvider: PokedexServiceProvider.Type

    public func fetchPokemonList<T>(paginationState: PaginationState<T> = .initial(pageLimit: 20), completion: @escaping (_ result: Result<PKMPagedObject<T>, Error>) -> Void) where T: PKMPokemon {
        self.serviceProvider.fetchPokemonList(paginationState: paginationState, completion: completion)
    }
    
    public func fetchPokemon(_ pokemonName: String, completion: @escaping (_ result: Result<PKMPokemon, Error>) -> Void) {
        self.serviceProvider.fetchPokemon(pokemonName, completion: completion)
    }
    
    init(serviceProvider: PokedexServiceProvider.Type = PokedexService.self) {
        self.serviceProvider = serviceProvider
    }
    
}

class PokedexService: PokedexServiceProvider {
    static func fetchPokemon(_ pokemonName: String, completion: @escaping (Result<PKMPokemon, Error>) -> Void) {
        PokedexApp.shared.service.pokemonService.fetchPokemon(pokemonName, completion: completion)
    }
    
    static func fetchPokemonList<T>(paginationState: PaginationState<T>, completion: @escaping (Result<PKMPagedObject<T>, Error>) -> Void) where T : PKMPokemon {
        PokedexApp.shared.service.pokemonService.fetchPokemonList(paginationState: paginationState, completion: completion)
    }
    
}
