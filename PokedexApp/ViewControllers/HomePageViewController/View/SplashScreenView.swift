//
//  SplashScreenView.swift
//  PokedexApp
//
//  Created by Giovanni Prestigiacomo on 06/03/22.
//

import UIKit
import Lottie

class SplashScreenView: UIView {
    
    private var loaderView: AnimationView = AnimationView(name: "splash_screen_loader")
    private var lblAppName: UILabel = UILabel()
    private var splashScreenHeight: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    public func configure(on view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = true
        
        view.addSubview(self)
        
        let splashScreenConstraints: [NSLayoutConstraint] = [
            self.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ]
        self.splashScreenHeight = self.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height)
        self.splashScreenHeight.isActive = true
        NSLayoutConstraint.activate(splashScreenConstraints)
        view.bringSubviewToFront(self)
    }
    
    public func dismiss() {
        self.splashScreenHeight.constant = 0
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
    
    // MARK: - Private methods
    
    private func configure() {
        self.configureConstraints()
        self.configureAppearance()
        self.configureLoader()
    }
    
    private func configureAppearance() {
        self.backgroundColor = .white
        self.lblAppName.attributedText = PokedexApp.shared.mainAttributedString
    }
    
    private func configureLoader() {
        self.loaderView.loopMode = .loop
        self.loaderView.contentMode = .scaleAspectFit
        self.loaderView.play()
    }
    
    private func configureConstraints() {
        self.lblAppName.translatesAutoresizingMaskIntoConstraints = false
        self.loaderView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(lblAppName)
        self.addSubview(loaderView)
        
        let loaderViewConstraints: [NSLayoutConstraint] = [
            self.loaderView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            self.loaderView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -50),
            self.loaderView.widthAnchor.constraint(equalToConstant: 200),
            self.loaderView.heightAnchor.constraint(equalToConstant: 200)
        ]
        
        let lblAppNameConstraints: [NSLayoutConstraint] = [
            self.lblAppName.topAnchor.constraint(equalTo: loaderView.bottomAnchor, constant: 50),
            self.lblAppName.centerXAnchor.constraint(equalTo: self.loaderView.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(loaderViewConstraints)
        NSLayoutConstraint.activate(lblAppNameConstraints)
    }

}

