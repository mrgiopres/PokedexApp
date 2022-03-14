//
//  WideScreenLoaderTableViewCell.swift
//  PokedexApp
//
//  Created by Giovanni Prestigiacomo on 12/03/22.
//

import Foundation
import UIKit
import Lottie

class WideScreenLoaderTableViewCell: UITableViewCell {
    private var loaderView: AnimationView = AnimationView(name: "widescreen_loader")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureConstraints()
        self.loaderView.loopMode = .loop
        self.loaderView.play()
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        self.loaderView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(loaderView)
        
        let loaderConstraints: [NSLayoutConstraint] = [
            self.loaderView.topAnchor.constraint(equalTo: self.topAnchor, constant: 200),
            self.loaderView.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 20),
            self.trailingAnchor.constraint(greaterThanOrEqualTo: self.loaderView.trailingAnchor, constant: 20),
            self.bottomAnchor.constraint(equalTo: self.loaderView.bottomAnchor, constant: 200),
            self.centerXAnchor.constraint(equalTo: self.loaderView.centerXAnchor),
            self.loaderView.heightAnchor.constraint(equalToConstant: 100)
        ]
        
        NSLayoutConstraint.activate(loaderConstraints)
    }
}
