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
    
    static let sh = MWInterface()
    
    weak var window: UIWindow?
    
    private lazy var tabBarController = MWMainTabBarController()
    
    private init() {}
    
    func setup(window: UIWindow?) {
        
        self.window = window

        self.setupNavigationBarStyle()

        window?.rootViewController = self.tabBarController
        window?.makeKeyAndVisible()
    }
    
    func push(_ vc: UIViewController) {
        guard let navigationController =
            self.tabBarController.selectedViewController as? UINavigationController else { return }
        navigationController.pushViewController(vc, animated: true)
    }
    
    func pop() {
        guard let navigationController = self.tabBarController.selectedViewController as? UINavigationController else { return }
        navigationController.popViewController(animated: true)
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
