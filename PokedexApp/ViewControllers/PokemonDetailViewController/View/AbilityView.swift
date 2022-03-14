//
//  AbilityView.swift
//  PokedexApp
//
//  Created by Giovanni Prestigiacomo on 13/03/22.
//

import Foundation
import UIKit

class AbilityTableViewCell: UITableViewCell {
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
        imageView.image = UIImage(named: "background_default")
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    private let lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 15, weight: .semibold)
        lbl.textColor = #colorLiteral(red: 0.2558671534, green: 0.2558671534, blue: 0.2558671534, alpha: 1)
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let lblEffect: UITextView = {
        let lbl = UITextView()
        lbl.backgroundColor = .clear
        lbl.font = .systemFont(ofSize: 15, weight: .regular)
        lbl.textColor = #colorLiteral(red: 0.2558671534, green: 0.2558671534, blue: 0.2558671534, alpha: 1)
        lbl.textAlignment = .left
        lbl.isScrollEnabled = true
        lbl.isEditable = false
        lbl.showsVerticalScrollIndicator = true
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.isUserInteractionEnabled = true
        self.selectionStyle = .none
        self.configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(title: String, description: String?) {
        self.lblTitle.text = title.capitalized.replacingOccurrences(of: "-", with: " ")
        if let description = description {
            self.lblEffect.text = description
        } else {
            self.lblTitle.textAlignment = .center
            self.lblTitle.font = .systemFont(ofSize: 15, weight: .regular)
            self.lblEffect.removeFromSuperview()
            NSLayoutConstraint.activate([
                self.cardView.bottomAnchor.constraint(equalTo: self.lblTitle.bottomAnchor, constant: 20)
            ])
        }
    }
    
    private func configureConstraints() {
        self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.cardView.translatesAutoresizingMaskIntoConstraints = false
        self.shadowView.translatesAutoresizingMaskIntoConstraints = false
        self.lblTitle.translatesAutoresizingMaskIntoConstraints = false
        self.lblEffect.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(shadowView)
        self.addSubview(cardView)
        self.cardView.addSubview(backgroundImageView)
        self.backgroundImageView.add(blurEffect: UIBlurEffect(style: .regular))
        self.cardView.addSubview(lblTitle)
        self.cardView.addSubview(lblEffect)
        
        let shadowConstraints: [NSLayoutConstraint] = [
            self.shadowView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.shadowView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.trailingAnchor.constraint(equalTo: self.shadowView.trailingAnchor, constant: 20),
            self.bottomAnchor.constraint(equalTo: self.shadowView.bottomAnchor, constant: 10),
            self.shadowView.heightAnchor.constraint(equalToConstant: 150)
        ]
        
        let cardConstraints: [NSLayoutConstraint] = [
            self.cardView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.cardView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: 20),
            self.bottomAnchor.constraint(equalTo: self.cardView.bottomAnchor, constant: 10),
            self.cardView.heightAnchor.constraint(equalToConstant: 150)
        ]
        
        let backgroundImageConstraints: [NSLayoutConstraint] = [
            self.backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            self.trailingAnchor.constraint(equalTo: self.backgroundImageView.trailingAnchor, constant: 0),
            self.bottomAnchor.constraint(equalTo: self.backgroundImageView.bottomAnchor, constant: 0)
        ]
        
        let titleConstraints: [NSLayoutConstraint] = [
            self.lblTitle.topAnchor.constraint(equalTo: self.cardView.topAnchor, constant: 20),
            self.lblTitle.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 20),
            self.cardView.trailingAnchor.constraint(equalTo: self.lblTitle.trailingAnchor, constant: 20),
            self.lblEffect.topAnchor.constraint(equalTo: self.lblTitle.bottomAnchor, constant: 15)
        ]
        
        let effectConstraints: [NSLayoutConstraint] = [
            self.lblEffect.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 20),
            self.cardView.trailingAnchor.constraint(equalTo: self.lblEffect.trailingAnchor, constant: 20),
            self.cardView.bottomAnchor.constraint(equalTo: self.lblEffect.bottomAnchor, constant: 20)
        ]
        
        NSLayoutConstraint.activate(shadowConstraints)
        NSLayoutConstraint.activate(cardConstraints)
        NSLayoutConstraint.activate(backgroundImageConstraints)
        NSLayoutConstraint.activate(titleConstraints)
        NSLayoutConstraint.activate(effectConstraints)
    }
}
