//
//  PokemonHeaderTableViewCell.swift
//  PokedexApp
//
//  Created by Giovanni Prestigiacomo on 12/03/22.
//

import Foundation
import UIKit
import Lottie

class PokemonHeaderTableViewCell: UITableViewCell {
    
    private let shadowView: UIView = {
        let card = UIView()
        card.backgroundColor = UIColor.white
        card.layer.cornerRadius = 20
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOffset = CGSize(width: 5, height: 5)
        card.layer.shadowRadius = 7
        card.layer.shadowOpacity = 0.1
        card.clipsToBounds = false
        card.isUserInteractionEnabled = true
        return card
    }()
    
    private let cardView: UIView = {
        let card = UIView()
        card.backgroundColor = UIColor.clear
        card.layer.cornerRadius = 20
        card.clipsToBounds = true
        card.isUserInteractionEnabled = true
        return card
    }()
    
    private var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    private var cloudAnimation = AnimationView(name: "clouds")
    
    private var imagePokemon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    private var loader = AnimationView(name: "widescreen_loader")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with pokemonImage: UIImage?) {
        if let pokemonImage = pokemonImage {
            self.cloudAnimation.loopMode = .loop
            self.cloudAnimation.play()
            self.imagePokemon.isHidden = false
            self.backgroundImageView.isHidden = false
            self.loader.isHidden = true
            self.loader.stop()
        
            self.backgroundImageView.image = pokemonImage
            self.imagePokemon.image = pokemonImage
        } else {
            self.imagePokemon.isHidden = true
            self.backgroundImageView.isHidden = true
            self.loader.isHidden = false
            
            self.loader.play()
        }
    }
    
    private func configureConstraints() {
        self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.cardView.translatesAutoresizingMaskIntoConstraints = false
        self.imagePokemon.translatesAutoresizingMaskIntoConstraints = false
        self.shadowView.translatesAutoresizingMaskIntoConstraints = false
        self.loader.translatesAutoresizingMaskIntoConstraints = false
        self.cloudAnimation.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(shadowView)
        self.addSubview(cardView)
        self.cardView.addSubview(backgroundImageView)
        self.backgroundImageView.add(blurEffect: UIBlurEffect(style: .regular))
        self.cardView.addSubview(cloudAnimation)
        self.cardView.addSubview(imagePokemon)
        self.cardView.addSubview(loader)
        
        let animationConstraints: [NSLayoutConstraint] = [
            self.cloudAnimation.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            self.cloudAnimation.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.trailingAnchor.constraint(equalTo: self.cloudAnimation.trailingAnchor, constant: 20),
            self.bottomAnchor.constraint(equalTo: self.cloudAnimation.bottomAnchor, constant: 20),
            self.cloudAnimation.heightAnchor.constraint(equalToConstant: 300)
        ]
        
        let shadowConstraints: [NSLayoutConstraint] = [
            self.shadowView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            self.shadowView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.trailingAnchor.constraint(equalTo: self.shadowView.trailingAnchor, constant: 20),
            self.bottomAnchor.constraint(equalTo: self.shadowView.bottomAnchor, constant: 20),
            self.shadowView.heightAnchor.constraint(equalToConstant: 300)
        ]
        
        let cardConstraints: [NSLayoutConstraint] = [
            self.cardView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            self.cardView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: 20),
            self.bottomAnchor.constraint(equalTo: self.cardView.bottomAnchor, constant: 20),
            self.cardView.heightAnchor.constraint(equalToConstant: 300)
        ]
        
        let backgroundImageConstraints: [NSLayoutConstraint] = [
            self.backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: -50),
            self.backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -50),
            self.trailingAnchor.constraint(equalTo: self.backgroundImageView.trailingAnchor, constant: -50),
            self.bottomAnchor.constraint(equalTo: self.backgroundImageView.bottomAnchor, constant: -50)
        ]
        
        let imageConstraints: [NSLayoutConstraint] = [
            self.cardView.trailingAnchor.constraint(equalTo: self.imagePokemon.trailingAnchor, constant: 0),
            self.cardView.bottomAnchor.constraint(equalTo: self.imagePokemon.bottomAnchor, constant: 30),
            self.imagePokemon.topAnchor.constraint(greaterThanOrEqualTo: self.cardView.topAnchor, constant: 10),
            self.imagePokemon.leadingAnchor.constraint(greaterThanOrEqualTo: self.cardView.leadingAnchor, constant: 0)
        ]
        
        let loaderConstraints: [NSLayoutConstraint] = [
            self.loader.centerYAnchor.constraint(equalTo: self.cardView.centerYAnchor),
            self.loader.centerXAnchor.constraint(equalTo: self.cardView.centerXAnchor),
            self.loader.heightAnchor.constraint(equalToConstant: 100),
            self.loader.widthAnchor.constraint(equalToConstant: 100)
        ]
                
        NSLayoutConstraint.activate(cardConstraints)
        NSLayoutConstraint.activate(animationConstraints)
        NSLayoutConstraint.activate(backgroundImageConstraints)
        NSLayoutConstraint.activate(imageConstraints)
        NSLayoutConstraint.activate(shadowConstraints)
        NSLayoutConstraint.activate(loaderConstraints)
    }
}
