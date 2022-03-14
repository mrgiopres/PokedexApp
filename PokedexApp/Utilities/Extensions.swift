//
//  Extensions.swift
//  PokedexApp
//
//  Created by Giovanni Prestigiacomo on 08/03/22.
//

import Foundation
import UIKit

extension UIViewController {
    func embedInNavigationController() -> UINavigationController {
        let nc = UINavigationController(rootViewController: self)
        
        nc.navigationBar.barTintColor = .white
        nc.navigationBar.tintColor = #colorLiteral(red: 0.2558671534, green: 0.2558671534, blue: 0.2558671534, alpha: 1)
        
        nc.navigationBar.shadowImage = UIImage()
        nc.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)

        nc.navigationBar.isTranslucent = false
        nc.modalPresentationStyle = .fullScreen
        
        nc.navigationBar.customizeAppearance(tintColor: #colorLiteral(red: 0.2558671534, green: 0.2558671534, blue: 0.2558671534, alpha: 1))
        
        return nc
    }
    
    func setDefaultBackButton(title: String = "Indietro", imageTitle: String = "icon_back") {
        let imgBackArrow = UIImage(named: imageTitle)

        navigationController?.navigationBar.backIndicatorImage = imgBackArrow
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = imgBackArrow

        let backButton = UIBarButtonItem()
        backButton.title = title
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
}

public extension UINavigationItem {
    @available(iOS 13.0, *)
    func setupRightAppearance() {
        if self.largeTitleDisplayMode == .never {
            let navigationCompactBarAppearance = UINavigationBarAppearance()
                navigationCompactBarAppearance.configureWithDefaultBackground()
                navigationCompactBarAppearance.titleTextAttributes = UINavigationBar.defaultTitleTextAttributes
                navigationCompactBarAppearance.largeTitleTextAttributes = UINavigationBar.defaultTitleTextAttributes
            self.scrollEdgeAppearance = navigationCompactBarAppearance
        }
    }
}

extension UINavigationBar {
    
    static var defaultTitleTextAttributes : [NSAttributedString.Key : Any] = [.font : UIFont.systemFont(ofSize: 15, weight: .semibold),
                                                                              .foregroundColor: #colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)]
    static var defaultLargeTitleTextAttributes : [NSAttributedString.Key : Any] = [.font : UIFont.systemFont(ofSize: 34, weight: .semibold),
                                                                                   .foregroundColor: #colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)]
    
    func customizeAppearance(tintColor: UIColor,
                             titleTextAttributes: [NSAttributedString.Key : Any] = UINavigationBar.defaultTitleTextAttributes,
                             largeTitleTextAttributes: [NSAttributedString.Key : Any] = UINavigationBar.defaultLargeTitleTextAttributes) {
        if #available(iOS 13.0, *) {
            let navigationCompactBarAppearance = UINavigationBarAppearance()
                navigationCompactBarAppearance.configureWithOpaqueBackground()
            let navigationLargeBarAppearance = UINavigationBarAppearance()
            navigationLargeBarAppearance.configureWithOpaqueBackground()
            navigationLargeBarAppearance.shadowColor = .clear
            navigationCompactBarAppearance.shadowColor = .clear
            navigationLargeBarAppearance.largeTitleTextAttributes = largeTitleTextAttributes
            navigationLargeBarAppearance.titleTextAttributes = titleTextAttributes
            navigationCompactBarAppearance.largeTitleTextAttributes = largeTitleTextAttributes
            navigationCompactBarAppearance.titleTextAttributes = titleTextAttributes
                self.standardAppearance = navigationCompactBarAppearance
                self.compactAppearance = navigationLargeBarAppearance
                self.scrollEdgeAppearance = navigationLargeBarAppearance
        }
        self.barTintColor = nil
        self.tintColor = tintColor
        self.titleTextAttributes = titleTextAttributes
        self.largeTitleTextAttributes = largeTitleTextAttributes
        self.shadowImage = nil
        self.setBackgroundImage(nil, for: .any, barMetrics: .default)
    }
}

extension UIView {
    public func add(blurEffect: UIBlurEffect) {
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        self.insertSubview(blurEffectView, at: 0)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            blurEffectView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            blurEffectView.topAnchor.constraint(equalTo: self.topAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

