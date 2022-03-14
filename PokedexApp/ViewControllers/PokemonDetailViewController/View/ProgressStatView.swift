//
//  ProgressStatView.swift
//  PokedexApp
//
//  Created by Giovanni Prestigiacomo on 13/03/22.
//

import Foundation
import UIKit

class ProgressStatView: UIView {
    
    static let MAX_PROGRESS: Float = 255
    
    private var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressViewStyle = .default
        progressView.progressTintColor = .lightGray
        progressView.layer.cornerRadius = progressView.frame.height/2
        return progressView
    }()
    
    private var lblName: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 15, weight: .regular)
        lbl.textColor = #colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)
        lbl.textAlignment = .left
        lbl.lineBreakMode = .byTruncatingMiddle
        lbl.numberOfLines = 1
        return lbl
    }()
    
    private var tagView: TagView = {
        let tagView = TagView()
        return tagView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with stat: Stat) {
        let progress: Float = Float(stat.baseStat)/ProgressStatView.MAX_PROGRESS
        self.progressView.setProgress(progress, animated: true)
        self.progressView.progressTintColor = stat.type.color().withAlphaComponent(0.8)
        self.progressView.trackTintColor = .lightGray.withAlphaComponent(0.1)
        self.lblName.text = stat.type.title()
        self.tagView.configure(text: "\(stat.baseStat)", color: stat.type.color(), fontSize: 10)
    }
    
    private func configureConstraints() {
        self.progressView.translatesAutoresizingMaskIntoConstraints = false
        self.lblName.translatesAutoresizingMaskIntoConstraints = false
        self.tagView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(progressView)
        self.addSubview(lblName)
        self.addSubview(tagView)
        
        let progressConstraints: [NSLayoutConstraint] = [
            self.trailingAnchor.constraint(equalTo: self.progressView.trailingAnchor, constant: 0),
            self.progressView.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width/2 - 20)),
            self.progressView.leadingAnchor.constraint(equalTo: self.tagView.trailingAnchor, constant: 10),
            self.progressView.heightAnchor.constraint(equalToConstant: 10),
            self.progressView.centerYAnchor.constraint(equalTo: self.lblName.centerYAnchor)
        ]

        let nameConstraints: [NSLayoutConstraint] = [
            self.lblName.topAnchor.constraint(equalTo: self.topAnchor, constant: 2),
            self.bottomAnchor.constraint(equalTo: self.lblName.bottomAnchor, constant: 2),
            self.lblName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
        ]
        
        let tagViewConstraints: [NSLayoutConstraint] = [
            self.tagView.leadingAnchor.constraint(greaterThanOrEqualTo: self.lblName.trailingAnchor, constant: 10),
            self.tagView.centerYAnchor.constraint(equalTo: self.lblName.centerYAnchor, constant: 0)
        ]

        NSLayoutConstraint.activate(progressConstraints)
        NSLayoutConstraint.activate(nameConstraints)
        NSLayoutConstraint.activate(tagViewConstraints)
    }
}
