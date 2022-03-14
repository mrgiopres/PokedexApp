//
//  AppDelegate.swift
//  PokedexApp
//
//  Created by Giovanni Prestigiacomo on 06/03/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let viewModel = HomePageViewModel(pokemonsPerPage: 30)
        let vc = HomePageViewController(viewModel: viewModel)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = vc.embedInNavigationController()
        window?.makeKeyAndVisible()
        return true
    }
}

