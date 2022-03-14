//
//  PokemonStatsTableViewCell.swift
//  PokedexApp
//
//  Created by Giovanni Prestigiacomo on 12/03/22.
//

import Foundation
import UIKit

class PokemonStatsTableViewCell: UITableViewCell {
    
    private var imageStat: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "stats")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 20, weight: .semibold)
        lbl.textColor = #colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)
        lbl.textAlignment = .left
        lbl.numberOfLines = 1
        lbl.text = "Statistics"
        return lbl
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 0
        stackView.axis = .vertical
        return stackView
    }()
    
    private var otherRatesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 0
        stackView.axis = .vertical
        return stackView
    }()
    
    private let separator: UIView = {
        let sep = UIView()
        sep.backgroundColor = .lightGray.withAlphaComponent(0.2)
        return sep
    }()
    
    override func prepareForReuse() {
        self.stackView.arrangedSubviews.forEach() { arrView in
            arrView.removeFromSuperview()
        }
        
        self.otherRatesStackView.arrangedSubviews.forEach() { arrView in
            arrView.removeFromSuperview()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureConstraints()
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with stats: [Stat], happiness: Int, captureRate: Int) {
        stats.forEach() { stat in
            let statView = ProgressStatView()
            statView.configure(with: stat)
            self.stackView.addArrangedSubview(statView)
            self.stackView.layoutIfNeeded()
        }
        
        let captureRateStatView = ProgressStatView()
        captureRateStatView.configure(with: Stat(name: "capture-rate", baseStat: captureRate, effort: 0))
        self.otherRatesStackView.addArrangedSubview(captureRateStatView)
        
        let happinessStatView = ProgressStatView()
        happinessStatView.configure(with: Stat(name: "happiness", baseStat: happiness, effort: 0))
        self.otherRatesStackView.addArrangedSubview(happinessStatView)

    }
    
    private func configureConstraints() {
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.lblTitle.translatesAutoresizingMaskIntoConstraints = false
        self.imageStat.translatesAutoresizingMaskIntoConstraints = false
        self.otherRatesStackView.translatesAutoresizingMaskIntoConstraints = false
        self.separator.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(lblTitle)
        self.addSubview(stackView)
        self.addSubview(otherRatesStackView)
        self.addSubview(imageStat)
        self.addSubview(separator)
        
        let lblViewConstraints: [NSLayoutConstraint] = [
            self.lblTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            self.lblTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.trailingAnchor.constraint(greaterThanOrEqualTo: self.lblTitle.trailingAnchor, constant: 20),
        ]
        
        let imageConstraints: [NSLayoutConstraint] = [
            self.imageStat.heightAnchor.constraint(equalToConstant: 20),
            self.imageStat.widthAnchor.constraint(equalToConstant: 20),
            self.imageStat.centerYAnchor.constraint(equalTo: self.lblTitle.centerYAnchor),
            self.imageStat.leadingAnchor.constraint(equalTo: self.lblTitle.trailingAnchor, constant: 15)
        ]
        
        let stackViewConstraints: [NSLayoutConstraint] = [
            self.stackView.topAnchor.constraint(equalTo: self.lblTitle.bottomAnchor, constant: 20),
            self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.trailingAnchor.constraint(equalTo: self.stackView.trailingAnchor, constant: 20),
            self.otherRatesStackView.topAnchor.constraint(equalTo: self.stackView.bottomAnchor, constant: 20)
        ]
        
        let otherStackViewConstraints: [NSLayoutConstraint] = [
            self.otherRatesStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.trailingAnchor.constraint(equalTo: self.otherRatesStackView.trailingAnchor, constant: 20),
        ]
        
        let separatorConstraints: [NSLayoutConstraint] = [
            self.separator.topAnchor.constraint(equalTo: self.otherRatesStackView.bottomAnchor, constant: 20),
            self.separator.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.trailingAnchor.constraint(equalTo: self.separator.trailingAnchor, constant: 20),
            self.bottomAnchor.constraint(equalTo: self.separator.bottomAnchor, constant: 0),
            self.separator.heightAnchor.constraint(equalToConstant: 1)
        ]
        
        NSLayoutConstraint.activate(lblViewConstraints)
        NSLayoutConstraint.activate(stackViewConstraints)
        NSLayoutConstraint.activate(imageConstraints)
        NSLayoutConstraint.activate(otherStackViewConstraints)
        NSLayoutConstraint.activate(separatorConstraints)
    }
}
