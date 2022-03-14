//
//  HomePageViewModel.swift
//  PokedexApp
//
//  Created by Giovanni Prestigiacomo on 06/03/22.
//

import Foundation
import PokemonAPI

class HomePageViewModel {
    public var pokemonPages: [PokemonPage] = []
    public var relevantPokemons: [Pokemon] = []
    
    var retrievedFirstPage: ((Bool) -> ())?
    var retrievedPage: ((Bool) -> ())?
    
    private var pokemonsPerPage: Int
    private var pageInstances: [PKMPagedObject<PKMPokemon>] = []
    var manager: PokedexManager
    
    init(pokemonsPerPage: Int, manager: PokedexManager = PokedexManager()) {
        self.pokemonsPerPage = pokemonsPerPage
        self.manager = manager
    }
    
    public func retrievePokemonList() {
        manager.fetchPokemonList(paginationState: .initial(pageLimit: self.pokemonsPerPage), completion: { result in
            var pokemonList: [Pokemon] = []
                        
            switch result {
            case .success(let resources):
                self.pageInstances.append(resources)
                resources.results?.forEach() { result in
                    if let pokemonObject = result as? PKMNamedAPIResource<PKMPokemon> {
                        if let pokemonURL = pokemonObject.url, let pokemonName = pokemonObject.name {
                            let pokemon = Pokemon(url: pokemonURL, name: pokemonName)
                            pokemonList.append(pokemon)
                        }
                    }
                }
                self.pokemonPages.append(PokemonPage(pokemons: pokemonList))
            case .failure(_):
                break
            }
            
            let group = DispatchGroup()
            
            for pokemonName in PokedexApp.shared.relevantPokemons {
                group.enter()
                self.manager.fetchPokemon(pokemonName, completion: { result in
                    switch result {
                    case .success(let pokemon):
                        let pokemonObject = Pokemon(url: "", name: pokemon.name ?? "")
                        pokemonObject.frontImageURL = pokemon.sprites?.frontDefault
                        pokemonObject.backImageURL = pokemon.sprites?.backDefault
                        pokemonObject.height = pokemon.height
                        pokemonObject.weight = pokemon.weight
                        pokemonObject.type = HomePageViewModel.getTypes(from: pokemon.types)
                        if let frontImage = Pokemon.getImageFromUrl(urlString: pokemonObject.frontImageURL ?? ""),
                            let backImage = Pokemon.getImageFromUrl(urlString: pokemonObject.backImageURL ?? "") {
                            pokemonObject.frontImage = frontImage
                            pokemonObject.backImage = backImage
                        }
                        self.relevantPokemons.append(pokemonObject)
                        print("fetchPokemonSuccess\n")
                    case .failure(_):
                        print("fetchPokemonFailure \(pokemonName)\n")
                    }
                    
                    group.leave()
                })
            }
            
            group.notify(queue: .main) {
                DispatchQueue.main.async {
                    self.retrievedFirstPage?(!pokemonList.isEmpty)
                }
            }
        })
    }
    
    static func getTypes(from pokemonTypes: [PKMPokemonType]?) -> [String] {
        guard let pokemonTypes = pokemonTypes else {
            return []
        }

        var types: [String] = []
        for type in pokemonTypes {
            if let typeString = type.type?.name {
                types.append(typeString)
            }
        }
        
        return types
    }
    
    public func retrievePokemonPage(for relationship: PaginationRelationship) {
        
        guard let lastPageInstance = self.pageInstances.last else {
            self.retrievedPage?(false)
            return
        }

        manager.fetchPokemonList(paginationState: .continuing(lastPageInstance, relationship), completion: { result in
            var pokemonList: [Pokemon] = []
            switch result {
            case .success(let resources):
                self.pageInstances.append(resources)
                resources.results?.forEach() { result in
                    if let pokemonObject = result as? PKMNamedAPIResource<PKMPokemon> {
                        if let pokemonURL = pokemonObject.url, let pokemonName = pokemonObject.name {
                            let pokemon = Pokemon(url: pokemonURL, name: pokemonName)
                            pokemonList.append(pokemon)
                        }
                    }
                }
                self.pokemonPages.append(PokemonPage(pokemons: pokemonList))

            case .failure(_):
                break
            }
            self.retrievedPage?(!pokemonList.isEmpty)
        })
    }
}

/// Non testable
extension HomePageViewModel {
    public func openPokemonDetail(pokemonID: String, from viewController: UIViewController) {
        let pokemonDetailViewModel = PokemonDetailViewModel(pokemonName: pokemonID)
        let pokemonDetailViewController = PokemonDetailViewController(viewModel: pokemonDetailViewModel)
        
        viewController.navigationController?.pushViewController(pokemonDetailViewController, animated: true)
    }
    
    public func startSearchFlow(from viewController: UIViewController) {
        let searchViewModel = SearchViewModel(homePageViewModel: self)
        let searchViewController = SearchViewController(viewModel: searchViewModel)

        viewController.navigationController?.pushViewController(searchViewController, animated: true)
    }
}
