//
//  PokemonCardViewCell.swift
//  PokedexApp
//
//  Created by Giovanni Prestigiacomo on 09/03/22.
//

import Foundation
import UIKit

class PokemonCardViewCell: UICollectionViewCell {
    
    static public var STD_DIMENSION: CGFloat = 175
    
    private let shadowView: UIView = {
        let card = UIView()
        card.backgroundColor = UIColor.white
        card.layer.cornerRadius = 20
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOffset = CGSize(width: 5, height: 5)
        card.layer.shadowRadius = 10
        card.layer.shadowOpacity = 0.1
        card.clipsToBounds = false
        card.isUserInteractionEnabled = true
        return card
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 3
        stackView.axis = .vertical
        return stackView
    }()
    
    private let cardView: UIView = {
        let card = UIView()
        card.backgroundColor = UIColor.clear
        card.layer.cornerRadius = 20
        card.clipsToBounds = true
        card.isUserInteractionEnabled = true
        return card
    }()
    
    private let lblPokemonName: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.isUserInteractionEnabled = false
        return lbl
    }()
    
    private let bookImage: UIImageView = {
        let bookImage = UIImageView()
        bookImage.image = UIImage(named: "chevron_right")
        return bookImage
    }()
    
    private var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    private var imagePokemon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .bottom
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    private var pokemon: Pokemon?
    private var tags: [TagView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.imagePokemon.image = nil
        self.lblPokemonName.text = nil
        for tag in self.tags {
            tag.removeFromSuperview()
        }
    }
    
    public func configure(with pokemon: Pokemon?) {
        self.pokemon = pokemon
        self.configureData()
    }
    
    private func configureData() {
        self.lblPokemonName.text = self.pokemon?.getPrettyName()
        self.imagePokemon.image = self.pokemon?.frontImage ?? UIImage(named: "dummy_image")
        self.backgroundImageView.image = self.pokemon?.frontImage ?? UIImage(named: "dummy_image")
        
        self.tags = []
        
        var numberOfTags = 0
        if let types = pokemon?.type {
            for type in types {
                if numberOfTags <= 2 {
                    let tagView = TagView()
                    tagView.configure(text: type.uppercased(), color: .lightGray)
                    self.tags.append(tagView)
                    self.stackView.addArrangedSubview(tagView)
                    numberOfTags += 1
                } else if numberOfTags == 3 {
                    let tagView = TagView()
                    tagView.configure(text: "...", color: .lightGray)
                    self.tags.append(tagView)
                    self.stackView.addArrangedSubview(tagView)
                    numberOfTags += 1
                }
            }
        }
    }
    
    private func configureConstraints() {
        self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.cardView.translatesAutoresizingMaskIntoConstraints = false
        self.lblPokemonName.translatesAutoresizingMaskIntoConstraints = false
        self.imagePokemon.translatesAutoresizingMaskIntoConstraints = false
        self.bookImage.translatesAutoresizingMaskIntoConstraints = false
        self.shadowView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(shadowView)
        self.addSubview(cardView)
        self.cardView.addSubview(backgroundImageView)
        self.backgroundImageView.add(blurEffect: UIBlurEffect(style: .regular))
        self.cardView.addSubview(lblPokemonName)
        self.cardView.addSubview(imagePokemon)
        self.cardView.addSubview(bookImage)
        self.cardView.addSubview(stackView)
        
        let shadowConstraints: [NSLayoutConstraint] = [
            self.shadowView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.shadowView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            self.trailingAnchor.constraint(equalTo: self.shadowView.trailingAnchor, constant: 0),
            self.bottomAnchor.constraint(equalTo: self.shadowView.bottomAnchor, constant: 0)
        ]
        
        let cardConstraints: [NSLayoutConstraint] = [
            self.cardView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.cardView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            self.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: 0),
            self.bottomAnchor.constraint(equalTo: self.cardView.bottomAnchor, constant: 0)
        ]
        
        let lblConstraints: [NSLayoutConstraint] = [
            self.lblPokemonName.topAnchor.constraint(equalTo: self.cardView.topAnchor, constant: 20),
            self.lblPokemonName.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 20),
            self.cardView.bottomAnchor.constraint(greaterThanOrEqualTo: self.lblPokemonName.bottomAnchor, constant: 20)
        ]
        
        let bookImageConstraints: [NSLayoutConstraint] = [
            self.bookImage.heightAnchor.constraint(equalToConstant: 20),
            self.bookImage.widthAnchor.constraint(equalToConstant: 20),
            self.bookImage.topAnchor.constraint(equalTo: self.cardView.topAnchor, constant: 20),
            self.bookImage.leadingAnchor.constraint(greaterThanOrEqualTo: self.lblPokemonName.trailingAnchor, constant: 20),
            self.cardView.trailingAnchor.constraint(equalTo: self.bookImage.trailingAnchor, constant: 20),
        ]
        
        let backgroundImageConstraints: [NSLayoutConstraint] = [
            self.backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            self.trailingAnchor.constraint(equalTo: self.backgroundImageView.trailingAnchor, constant: -30),
            self.bottomAnchor.constraint(equalTo: self.backgroundImageView.bottomAnchor, constant: -30)
        ]
        
        let imageConstraints: [NSLayoutConstraint] = [
            self.cardView.trailingAnchor.constraint(equalTo: self.imagePokemon.trailingAnchor, constant: 20),
            self.cardView.bottomAnchor.constraint(equalTo: self.imagePokemon.bottomAnchor, constant: 20),
            self.imagePokemon.topAnchor.constraint(greaterThanOrEqualTo: self.cardView.topAnchor, constant: 20),
            self.imagePokemon.leadingAnchor.constraint(greaterThanOrEqualTo: self.cardView.leadingAnchor, constant: 20),
            self.imagePokemon.heightAnchor.constraint(equalToConstant: 100),
            self.imagePokemon.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let stackViewConstraints: [NSLayoutConstraint] = [
            self.cardView.trailingAnchor.constraint(greaterThanOrEqualTo: self.stackView.trailingAnchor, constant: 20),
            self.cardView.bottomAnchor.constraint(equalTo: self.stackView.bottomAnchor, constant: 20),
            self.stackView.topAnchor.constraint(greaterThanOrEqualTo: self.cardView.topAnchor, constant: 20),
            self.stackView.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 20)
        ]
        
        NSLayoutConstraint.activate(cardConstraints)
        NSLayoutConstraint.activate(backgroundImageConstraints)
        NSLayoutConstraint.activate(lblConstraints)
        NSLayoutConstraint.activate(imageConstraints)
        NSLayoutConstraint.activate(bookImageConstraints)
        NSLayoutConstraint.activate(shadowConstraints)
        NSLayoutConstraint.activate(stackViewConstraints)
        
        self.cardView.layoutSubviews()
    }
}
