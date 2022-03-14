//
//  PokemonAbilitiesTableViewCell.swift
//  PokedexApp
//
//  Created by Giovanni Prestigiacomo on 12/03/22.
//

import Foundation
import UIKit

protocol PokemonAbilitiesDelegate {
    func retrieved(abilities: [Ability])
}

class PokemonAbilitiesTableViewCell: UITableViewCell {
    
    private var imageAbilities: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "abilities")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 20, weight: .semibold)
        lbl.textColor = #colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)
        lbl.textAlignment = .left
        lbl.numberOfLines = 1
        lbl.text = "Abilities"
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var viewModel: AbilityViewModel?
    private var delegate: PokemonAbilitiesDelegate?
        
    public func configure(viewModel: AbilityViewModel?, delegate: PokemonAbilitiesDelegate?) {
        self.delegate = delegate
        self.viewModel = viewModel
        self.viewModel?.retrievedAbility = { hasSucceeded in
            DispatchQueue.main.async {
                if hasSucceeded, let abilities = self.viewModel?.abilities {
                    self.delegate?.retrieved(abilities: abilities)
                }
            }
        }
        self.viewModel?.retrieveAbilities()
    }

private func configureConstraints() {
    self.lblTitle.translatesAutoresizingMaskIntoConstraints = false
        self.imageAbilities.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(lblTitle)
        self.addSubview(imageAbilities)
        
        let lblViewConstraints: [NSLayoutConstraint] = [
            self.lblTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            self.lblTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.trailingAnchor.constraint(greaterThanOrEqualTo: self.lblTitle.trailingAnchor, constant: 20),
            self.bottomAnchor.constraint(equalTo: self.lblTitle.bottomAnchor, constant: 10)
        ]
        
        let imageConstraints: [NSLayoutConstraint] = [
            self.imageAbilities.heightAnchor.constraint(equalToConstant: 20),
            self.imageAbilities.widthAnchor.constraint(equalToConstant: 20),
            self.imageAbilities.centerYAnchor.constraint(equalTo: self.lblTitle.centerYAnchor),
            self.imageAbilities.leadingAnchor.constraint(equalTo: self.lblTitle.trailingAnchor, constant: 15)
        ]
            
        NSLayoutConstraint.activate(imageConstraints)
        NSLayoutConstraint.activate(lblViewConstraints)
    }
}
