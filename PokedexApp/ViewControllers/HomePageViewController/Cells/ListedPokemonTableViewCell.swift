//
//  ListedPokemonTableViewCell.swift
//  PokedexApp
//
//  Created by Giovanni Prestigiacomo on 12/03/22.
//

import Foundation
import UIKit

class ListedPokemonTableViewCell : UITableViewCell {
    
    private var lblName: UILabel = {
        let lblName = UILabel()
        lblName.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        lblName.textColor = #colorLiteral(red: 0.2558671534, green: 0.2558671534, blue: 0.2558671534, alpha: 1)
        lblName.numberOfLines = 0
        return lblName
    }()
    
    private var chevron: UIImageView = {
        let chevron = UIImageView()
        chevron.contentMode = .scaleAspectFit
        chevron.image = UIImage(named: "chevron_right")
        return chevron
    }()
    
    private var pokemonID: String = ""
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureConstraints()
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with name: String, identifier: String) {
        self.pokemonID = identifier
        self.lblName.text = name
    }
    
    private func configureConstraints() {
        self.chevron.translatesAutoresizingMaskIntoConstraints = false
        self.lblName.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(chevron)
        self.addSubview(lblName)
        
        let lblConstraints: [NSLayoutConstraint] = [
            self.lblName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            self.lblName.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.bottomAnchor.constraint(equalTo: self.lblName.bottomAnchor, constant: 10),
            self.chevron.leadingAnchor.constraint(greaterThanOrEqualTo: self.lblName.trailingAnchor, constant: 15)
        ]
        
        let chevronConstraints: [NSLayoutConstraint] = [
            self.chevron.centerYAnchor.constraint(equalTo: self.lblName.centerYAnchor),
            self.trailingAnchor.constraint(equalTo: self.chevron.trailingAnchor, constant: 15),
            self.chevron.heightAnchor.constraint(equalToConstant: 15)
        ]
        
        NSLayoutConstraint.activate(lblConstraints)
        NSLayoutConstraint.activate(chevronConstraints)
    }
}
