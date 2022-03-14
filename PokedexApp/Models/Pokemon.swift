//
//  Pokemon.swift
//  PokedexApp
//
//  Created by Giovanni Prestigiacomo on 06/03/22.
//

import Foundation
import UIKit
import PokemonAPI

class Pokemon {
    var id: String?
    var url: String
    var name: String
    var height: Int?
    var weight: Int?
    var baseExperience: Int?
    var highQualityImage: UIImage?
    var frontImageURL: String?
    var backImageURL: String?
    var frontImage: UIImage?
    var backImage: UIImage?
    var type: [String] = []
    var stats: [Stat] = []
    var isBaby: Bool?
    var captureRate: Int?
    var happiness: Int?
    var abilities: [String]?
    
    init(url: String, name: String) {
        self.name = name
        self.url = url
    }
    
    public func getPrettyName() -> String {
        return name.replacingOccurrences(of: "-", with: " ").capitalized
    }
    
    static func getImageFromUrl(urlString: String) -> UIImage? {
        if let data = try? Data(contentsOf: URL(string: urlString) ?? URL(fileURLWithPath: "")) {
            return UIImage(data: data)
        } else {
            return nil
        }
    }
    
    static func getHighQualityImage(for id: String) -> UIImage? {
        let url: String = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/" + id + ".png"
        if let data = try? Data(contentsOf: URL(string: url) ?? URL(fileURLWithPath: "")) {
            return UIImage(data: data)
        } else {
            return nil
        }
    }
}
