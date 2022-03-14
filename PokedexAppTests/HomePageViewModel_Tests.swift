//
//  HomePageViewModel_Tests.swift
//  HomePageViewModel_Tests
//
//  Created by Giovanni Prestigiacomo on 06/03/22.
//

import XCTest
import PokemonAPI
@testable import PokedexApp

class HomePageViewModel_Tests: XCTestCase {
    
    func test_retrievePokemonList_shouldSucceedRetrievingListAndRelevantPokemons() {
        // Given
        let viewModel = HomePageViewModel(pokemonsPerPage: 15, manager: PokedexManager(serviceProvider: PokedexManagerMockedServiceProvider.self))
        
        let expectation = XCTestExpectation(description: "Expect to have a success")
        var hasSucceeded: Bool = false
        
        viewModel.retrievedFirstPage = { success in
            print("\(success)")
            
            hasSucceeded = success
            expectation.fulfill()

        }

        // When
        viewModel.retrievePokemonList()
        
        
        // Then
        wait(for: [expectation], timeout: 6.0)
        XCTAssertTrue(hasSucceeded)
    }
    
    func test_retrievePokemonList_withFailingServiceCalls_shouldFail() {
        // Given
        let viewModel = HomePageViewModel(pokemonsPerPage: 15, manager: PokedexManager(serviceProvider: PokedexManagerMockedServiceErrorProvider.self))
        
        let expectation = XCTestExpectation(description: "Expect to have a failure")
        var hasSucceeded: Bool = false
        
        viewModel.retrievedFirstPage = { success in
            print("\(success)")
            
            hasSucceeded = success
            expectation.fulfill()

        }

        // When
        viewModel.retrievePokemonList()
        
        
        // Then
        wait(for: [expectation], timeout: 6.0)
        XCTAssertFalse(hasSucceeded)
    }
    
    
    func test_retrievePokemon_WithNoLastPage_ShouldFail() {
        // Given
        let viewModel = HomePageViewModel(pokemonsPerPage: 15, manager: PokedexManager(serviceProvider: PokedexManagerMockedServiceProvider.self))
                
        let expectation = XCTestExpectation(description: "Expect to have a failure")
        var hasSucceeded: Bool = false
        
        viewModel.retrievedPage = { success in
            print("\(success)")
            
            hasSucceeded = success
            expectation.fulfill()

        }

        // When
        viewModel.retrievePokemonPage(for: .next)
        
        
        // Then
        wait(for: [expectation], timeout: 6.0)
        XCTAssertFalse(hasSucceeded)
    }
    
    func test_retrievePokemon_WithLastPagePresent_ShouldSucceed() {
        // Given
        let viewModel = HomePageViewModel(pokemonsPerPage: 15, manager: PokedexManager(serviceProvider: PokedexManagerMockedServiceProvider.self))
                
        let expectation = XCTestExpectation(description: "Expect to have a success")
        var hasSucceeded: Bool = false
        
        viewModel.retrievedFirstPage = { success in
            viewModel.retrievePokemonPage(for: .next)
        }
        
        viewModel.retrievedPage = { success in
            print("\(success)")
            
            hasSucceeded = success
            expectation.fulfill()

        }

        // When
        viewModel.retrievePokemonList()
        
        
        // Then
        wait(for: [expectation], timeout: 6.0)
        XCTAssertTrue(hasSucceeded)
    }
    
    func test_retrievePokemon_WithLastPagePresentAndFailingServiceCall_ShouldFail() {
        // Given
        let viewModel = HomePageViewModel(pokemonsPerPage: 15, manager: PokedexManager(serviceProvider: PokedexManagerMockedServiceProvider.self))
                
        let expectation = XCTestExpectation(description: "Expect to have a success")
        var hasSucceeded: Bool = false
        
        viewModel.retrievedFirstPage = { success in
            viewModel.manager.serviceProvider = PokedexManagerMockedServiceErrorProvider.self
            viewModel.retrievePokemonPage(for: .next)
        }
        
        viewModel.retrievedPage = { success in
            print("\(success)")
            
            hasSucceeded = success
            expectation.fulfill()

        }

        // When
        viewModel.retrievePokemonList()
        
        
        // Then
        wait(for: [expectation], timeout: 6.0)
        XCTAssertFalse(hasSucceeded)
    }

}

class PokedexManagerMockedServiceProvider: PokedexServiceProvider {
    
    static var fetchPokemonListMock: String = "fetchlist"
    static var fetchPokemonMock: String = "fetchpokemon"
    
    static func fetchPokemonList<T>(paginationState: PaginationState<T>, completion: @escaping (Result<PKMPagedObject<T>, Error>) -> Void) where T : PKMPokemon {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
            if let bundle = Bundle.main.url(forResource: PokedexManagerMockedServiceProvider.fetchPokemonListMock, withExtension: ".json"),
                    let data = try? Data(contentsOf: bundle) {
                do {
                    let pagedObject = try PKMPagedObject<T>.decode(from: data)
                    completion(.success(pagedObject))
                } catch {
                    completion(.failure(BasicError()))
                }
            } else {
                completion(.failure(BasicError()))
            }
        })
    }
    
    static func fetchPokemon(_ pokemonName: String, completion: @escaping (Result<PKMPokemon, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
            if let bundle = Bundle.main.url(forResource: PokedexManagerMockedServiceProvider.fetchPokemonMock, withExtension: ".json"),
               let data = try? Data(contentsOf: bundle) {
                do {
                    let pokemon = try PKMPokemon.decode(from: data)
                    completion(.success(pokemon))
                } catch {
                    completion(.failure(BasicError()))
                }
            } else {
                completion(.failure(BasicError()))
            }
        })
    }
}

class PokedexManagerMockedServiceErrorProvider: PokedexServiceProvider {
    
    static var fetchPokemonListMock: String = "fetchlist"
    static var fetchPokemonMock: String = "fetchpokemon"
    
    static func fetchPokemonList<T>(paginationState: PaginationState<T>, completion: @escaping (Result<PKMPagedObject<T>, Error>) -> Void) where T : PKMPokemon {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
            completion(.failure(BasicError()))
        })
    }
    
    static func fetchPokemon(_ pokemonName: String, completion: @escaping (Result<PKMPokemon, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
            completion(.failure(BasicError()))
        })
    }
}

class BasicError: Error {
}

