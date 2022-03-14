//
//  SearchView.swift
//  PokedexApp
//
//  Created by Giovanni Prestigiacomo on 13/03/22.
//

import Foundation
import UIKit

protocol SearchDelegate {
    func startSearch(type: String?, name: String?)
}

class SearchView: UIView {
    
    private var textField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 15, weight: .regular)
        textField.textAlignment = .left
        textField.isUserInteractionEnabled = true
        textField.placeholder = "Search by Pokémon name"
        textField.layer.cornerRadius = textField.bounds.height/2
        let imageView = UIImageView(frame: CGRect(x: 0.0, y: 8.0, width: 24.0, height: 24.0))
        let image = UIImage(named: "cta_search")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        imageView.tintColor = .lightGray

        let view = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 40))
        view.addSubview(imageView)
        view.backgroundColor = .white
        textField.leftViewMode = UITextField.ViewMode.always
        textField.leftView = view
        return textField
    }()
    
    private var types: [String] = []
    private var selectedType: String?
    var delegate: SearchDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureConstraints()
        self.backgroundColor = .white
        self.textField.delegate = self
        self.textField.addTarget(self, action: #selector(textFieldUpdate), for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func textFieldUpdate() {
        self.delegate?.startSearch(type: "", name: self.textField.text)
    }
        
    private func configureConstraints() {
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(textField)
        
        let textFieldConstraints: [NSLayoutConstraint] = [
            self.textField.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            self.textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.trailingAnchor.constraint(equalTo: self.textField.trailingAnchor, constant: 20),
            self.bottomAnchor.constraint(equalTo: self.textField.bottomAnchor, constant: 20)
        ]

        NSLayoutConstraint.activate(textFieldConstraints)
    }
}

extension SearchView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.startSearch(type: "", name: self.textField.text)
    }
}

