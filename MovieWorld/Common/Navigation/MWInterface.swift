//
//  MWInterface.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 2/22/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

typealias MWI = MWInterface

class MWInterface {
    
    // MARK: - variables
    
    static let sh = MWInterface()
    
    let tabBarController = MWMainTabBarController()

    weak var window: UIWindow?
    
    // MARK: - init
    
    private init() {}
    
    // MARK: - functions
    
    func setup(window: UIWindow?) {
        
        self.window = window

        self.setupNavigationBarStyle()

        window?.rootViewController = MWInitController()
        window?.makeKeyAndVisible()
    }
    
    func push(_ vc: UIViewController) {
        (self.tabBarController.selectedViewController as? UINavigationController)?
            .pushViewController(vc, animated: true)
    }
    
    func pop() {
        (self.tabBarController.selectedViewController as? UINavigationController)?
            .popViewController(animated: true)
    }
    
    private func setupNavigationBarStyle() {
        let standartNavBar = UINavigationBar.appearance()
        standartNavBar.tintColor = UIColor(named: "accentColor")
        standartNavBar.prefersLargeTitles = true
        standartNavBar.largeTitleTextAttributes =
            [.foregroundColor: UIColor(named: "textColor") ?? UIColor.black]
        
        if #available(iOS 13.0, *) {
            let newNavBar = UINavigationBarAppearance()
            newNavBar.configureWithDefaultBackground()
            newNavBar.largeTitleTextAttributes =
                [.foregroundColor: UIColor(named: "textColor") ?? UIColor.black]
            standartNavBar.scrollEdgeAppearance = newNavBar
        }
    }
    
}
