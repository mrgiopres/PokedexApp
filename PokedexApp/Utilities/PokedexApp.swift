//
//  PokedexApp.swift
//  PokedexApp
//
//  Created by Giovanni Prestigiacomo on 08/03/22.
//

import Foundation
import UIKit
import PokemonAPI

class PokedexApp {
    static var shared: PokedexApp = PokedexApp()
    
    var mainAttributedString: NSAttributedString {
        let lblPokedex = NSAttributedString(string: "pokedex", attributes: [.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 40, weight: .semibold)])
        let lblApp = NSAttributedString(string: "app", attributes: [.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 40, weight: .light)])
        let lblAttributedString = NSMutableAttributedString(attributedString: lblPokedex)
        lblAttributedString.append(lblApp)
        return lblAttributedString
    }
    
    public var service: PokemonAPI {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
            
        let urlSession = URLSession(configuration: configuration)
        return PokemonAPI(session: urlSession)

    }
    
    public var relevantPokemons: [String] = [ "pikachu",
                                              "igglybuff",
                                              "charmander",
                                              "rayquaza",
                                              "eevee",
                                              "charizard",
                                              "mewtwo",
                                              "bulbasaur",
                                              "gengar",
                                              "squirtle",
                                              "lucario",
                                              "gardevoir",
                                              "snorlax",
                                              "blastoise",
                                              "umbreon",
                                              "garchomp",
                                              "dragonite",
                                              "gyarados",
                                              "absol",
                                              "jigglypuff"
    ]
}
