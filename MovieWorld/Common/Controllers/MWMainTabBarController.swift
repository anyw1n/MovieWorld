//
//  MWMainTabBarController.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 2/22/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWMainTabBarController: UITabBarController {

    // MARK: - variables

    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }

    // MARK: - gui variables

    private let mainController: MWMainViewController = {
        let controller = MWMainViewController()
        controller.tabBarItem = UITabBarItem(title: "Main".localized(),
                                             image: UIImage(named: "mainTabBarIcon"),
                                             selectedImage: UIImage(named: "mainTabBarIcon"))
        return controller
    }()

    private let categoryController: MWCategoryViewController = {
        let controller = MWCategoryViewController()
        controller.tabBarItem = UITabBarItem(title: "Category".localized(),
                                             image: UIImage(named: "categoryTabBarIcon"),
                                             selectedImage: UIImage(named: "categoryTabBarIcon"))
        return controller
    }()

    private let searchController: MWSearchViewController = {
        let controller = MWSearchViewController()
        controller.tabBarItem = UITabBarItem(title: "Search".localized(),
                                             image: UIImage(named: "searchTabBarIcon"),
                                             selectedImage: UIImage(named: "searchTabBarIcon"))
        return controller
    }()

    // MARK: - lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let controllers: [UIViewController] = [self.mainController,
                                               self.categoryController,
                                               self.searchController]
        self.viewControllers = controllers.map { UINavigationController(rootViewController: $0) }

        self.tabBar.tintColor = UIColor(named: "accentColor")
        self.tabBar.unselectedItemTintColor = UIColor(named: "textColor")
    }
}
