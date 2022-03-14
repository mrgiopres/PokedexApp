//
//  PokemonCharacteristicsTableViewCell.swift
//  PokedexApp
//
//  Created by Giovanni Prestigiacomo on 12/03/22.
//

import Foundation
import UIKit

class PokemonCharacteristicsTableViewCell: UITableViewCell {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 5
        return stackView
    }()
    
    private var imageChar: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "characteristics")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 20, weight: .semibold)
        lbl.textColor = #colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)
        lbl.textAlignment = .left
        lbl.numberOfLines = 1
        lbl.text = "Characteristics"
        return lbl
    }()
    private let lblType: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 15, weight: .regular)
        lbl.textColor = #colorLiteral(red: 0.2558671534, green: 0.2558671534, blue: 0.2558671534, alpha: 1)
        lbl.text = "Type: "
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let lblHeightWeight: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 15, weight: .regular)
        lbl.textColor = #colorLiteral(red: 0.2558671534, green: 0.2558671534, blue: 0.2558671534, alpha: 1)
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        return lbl
    }()
    
    private var lblExperience: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 15, weight: .regular)
        lbl.textColor = #colorLiteral(red: 0.2558671534, green: 0.2558671534, blue: 0.2558671534, alpha: 1)
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        lbl.text = "The base experience gained for defeating this Pokémon"
        return lbl
    }()
    
    private var lblBaby: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 15, weight: .regular)
        lbl.textColor = #colorLiteral(red: 0.2558671534, green: 0.2558671534, blue: 0.2558671534, alpha: 1)
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        lbl.text = "This is a baby Pokémon"
        return lbl
    }()
    
    private var tagView = TagView()
    
    private let separator: UIView = {
        let sep = UIView()
        sep.backgroundColor = .lightGray.withAlphaComponent(0.2)
        return sep
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        self.configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.stackView.arrangedSubviews.forEach() { arrangedSubview in
            arrangedSubview.removeFromSuperview()
        }
    }
    
    public func configure(with types: [String], weight: Int, height: Int, baseExperience: Int, isBaby: Bool) {
        let weightFloat = CGFloat(weight)/10
        let heightFloat = CGFloat(height)/10
        
        self.lblHeightWeight.text = "Weight: \(weightFloat) kg\nHeight: \(heightFloat) m"
        types.forEach() { tag in
            let tagView = TagView()
            tagView.configure(text: tag.uppercased(), color: .lightGray, fontSize: 15)
            self.stackView.addArrangedSubview(tagView)
        }
        
        if !isBaby {
            self.lblBaby.removeFromSuperview()
            NSLayoutConstraint.activate([
                self.separator.topAnchor.constraint(equalTo: self.lblExperience.bottomAnchor, constant: 20)
            ])
        } else {
            self.lblBaby.isHidden = false
        }
        
        self.tagView.configure(text: "\(baseExperience)", color: .blue.withAlphaComponent(0.5), fontSize: 15)
    }
    
    private func configureConstraints() {
        self.lblHeightWeight.translatesAutoresizingMaskIntoConstraints = false
        self.lblType.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.separator.translatesAutoresizingMaskIntoConstraints = false
        self.lblTitle.translatesAutoresizingMaskIntoConstraints = false
        self.imageChar.translatesAutoresizingMaskIntoConstraints = false
        self.lblExperience.translatesAutoresizingMaskIntoConstraints = false
        self.tagView.translatesAutoresizingMaskIntoConstraints = false
        self.lblBaby.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(lblHeightWeight)
        self.addSubview(lblType)
        self.addSubview(stackView)
        self.addSubview(separator)
        self.addSubview(lblTitle)
        self.addSubview(imageChar)
        self.addSubview(lblExperience)
        self.addSubview(tagView)
        self.addSubview(lblBaby)
        
        let imageCharConstraints: [NSLayoutConstraint] = [
            self.imageChar.heightAnchor.constraint(equalToConstant: 20),
            self.imageChar.widthAnchor.constraint(equalToConstant: 20),
            self.imageChar.centerYAnchor.constraint(equalTo: self.lblTitle.centerYAnchor),
            self.imageChar.leadingAnchor.constraint(equalTo: self.lblTitle.trailingAnchor, constant: 15)
        ]
        
        let lblTitleConstraints: [NSLayoutConstraint] = [
            self.lblTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            self.lblTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.trailingAnchor.constraint(greaterThanOrEqualTo: self.lblTitle.trailingAnchor, constant: 20),
        ]
        
        let lblHeightWeightConstraints: [NSLayoutConstraint] = [
            self.lblHeightWeight.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.trailingAnchor.constraint(equalTo: self.lblHeightWeight.trailingAnchor, constant: 20),
            self.lblHeightWeight.topAnchor.constraint(equalTo: self.lblType.bottomAnchor, constant: 20)
        ]
        
        let lblTypeConstraints: [NSLayoutConstraint] = [
            self.lblType.topAnchor.constraint(equalTo: self.lblTitle.bottomAnchor, constant: 20),
            self.lblType.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.stackView.leadingAnchor.constraint(greaterThanOrEqualTo: self.lblType.trailingAnchor, constant: 30)
        ]
        
        let stackViewConstraints: [NSLayoutConstraint] = [
            self.trailingAnchor.constraint(equalTo: self.stackView.trailingAnchor, constant: 20),
            self.stackView.centerYAnchor.constraint(equalTo: self.lblType.centerYAnchor, constant: 0)
        ]
        
        let separatorConstraints: [NSLayoutConstraint] = [
            self.separator.topAnchor.constraint(equalTo: self.lblBaby.bottomAnchor, constant: 20),
            self.separator.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.trailingAnchor.constraint(equalTo: self.separator.trailingAnchor, constant: 20),
            self.bottomAnchor.constraint(equalTo: self.separator.bottomAnchor, constant: 0),
            self.separator.heightAnchor.constraint(equalToConstant: 1)
        ]
        
        let lblExperienceConstraints: [NSLayoutConstraint] = [
            self.lblExperience.topAnchor.constraint(equalTo: self.lblHeightWeight.bottomAnchor, constant: 20),
            self.lblExperience.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.tagView.leadingAnchor.constraint(greaterThanOrEqualTo: self.lblExperience.trailingAnchor, constant: 20),
        ]
        
        let tagConstraints: [NSLayoutConstraint] = [
            self.tagView.centerYAnchor.constraint(equalTo: self.lblExperience.centerYAnchor),
            self.trailingAnchor.constraint(equalTo: self.tagView.trailingAnchor, constant: 20),
        ]
        
        let babyConstraints: [NSLayoutConstraint] = [
            self.lblBaby.topAnchor.constraint(equalTo: self.lblExperience.bottomAnchor, constant: 20),
            self.lblBaby.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.trailingAnchor.constraint(greaterThanOrEqualTo: self.lblBaby.trailingAnchor, constant: 20)
        ]
                
        NSLayoutConstraint.activate(lblHeightWeightConstraints)
        NSLayoutConstraint.activate(lblTypeConstraints)
        NSLayoutConstraint.activate(stackViewConstraints)
        NSLayoutConstraint.activate(separatorConstraints)
        NSLayoutConstraint.activate(imageCharConstraints)
        NSLayoutConstraint.activate(lblTitleConstraints)
        NSLayoutConstraint.activate(lblExperienceConstraints)
        NSLayoutConstraint.activate(tagConstraints)
        NSLayoutConstraint.activate(babyConstraints)
    }
}
