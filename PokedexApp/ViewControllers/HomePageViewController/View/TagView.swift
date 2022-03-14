//
//  TagView.swift
//  PokedexApp
//
//  Created by Giovanni Prestigiacomo on 09/03/22.
//

import Foundation
import UIKit

class TagView: UIView {
    
    private var tagView: UIView = {
        let tagView = UIView()
        tagView.layer.cornerRadius = 5
        tagView.isUserInteractionEnabled = false
        return tagView
    }()
    
    private var lblTag: UILabel = {
        let lblTag = UILabel()
        lblTag.numberOfLines = 1
        lblTag.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        lblTag.textColor = .white
        return lblTag
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setCircleCornerRadius() {
        self.tagView.layer.cornerRadius = self.frame.height/2
    }
    
    public func configure(text: String, color: UIColor, fontSize: Int? = nil) {
        self.tagView.backgroundColor = color
        self.lblTag.text = text
        
        if let fontSize = fontSize {
            self.lblTag.font = .systemFont(ofSize: CGFloat(fontSize), weight: .semibold)
        }
    }
    
    private func configureConstraints() {
        self.tagView.translatesAutoresizingMaskIntoConstraints = false
        self.lblTag.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(tagView)
        self.tagView.addSubview(lblTag)
        
        let viewConstraints: [NSLayoutConstraint] = [
            tagView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            tagView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            self.trailingAnchor.constraint(equalTo: tagView.trailingAnchor, constant: 0),
            self.bottomAnchor.constraint(equalTo: tagView.bottomAnchor, constant: 0)
        ]
        
        let lblConstraints: [NSLayoutConstraint] = [
            lblTag.topAnchor.constraint(equalTo: self.tagView.topAnchor, constant: 2),
            lblTag.leadingAnchor.constraint(equalTo: self.tagView.leadingAnchor, constant: 3),
            self.tagView.trailingAnchor.constraint(equalTo: lblTag.trailingAnchor, constant: 3),
            self.tagView.bottomAnchor.constraint(equalTo: lblTag.bottomAnchor, constant: 2)
        ]
        
        NSLayoutConstraint.activate(lblConstraints)
        NSLayoutConstraint.activate(viewConstraints)
    }
}
