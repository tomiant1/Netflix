//
//  ViewController.swift
//  Nextflix-Clone-App
//
//  Created by Tomi Antoljak on 11/26/22.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .systemYellow
        
        tabBar.tintColor = .label
        
        let viewController1 = UINavigationController(rootViewController: HomeViewController())
        
        let viewController2 = UINavigationController(rootViewController: UpcomingViewController())
        
        let viewController3 = UINavigationController(rootViewController: SearchViewController())
        
        let viewController4 = UINavigationController(rootViewController: DownloadsViewController())
        
        setViewControllers([viewController1, viewController2, viewController3, viewController4], animated: true)
        
        viewController1.tabBarItem.image = UIImage(systemName: "house")
        
        viewController2.tabBarItem.image = UIImage(systemName: "play.circle")
        
        viewController3.tabBarItem.image = UIImage(systemName: "magnifyingglass")

        viewController4.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        
        viewController1.title = "Home"
        
        viewController2.title = "Coming Soon"
        
        viewController3.title = "Top Search"
        
        viewController4.title = "Downloads"
        
    }


}

