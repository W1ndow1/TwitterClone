//
//  ViewController.swift
//  TwitterClone
//
//  Created by window1 on 2023/10/21.
//

import UIKit

class MainTabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UIBarButtonItem.appearance().tintColor = UIColor.black
        
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: SearchViewController())
        let vc3 = UINavigationController(rootViewController: NotificationViewController())
        let vc4 = UINavigationController(rootViewController: DirectMessagesViewController())
        
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc1.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        vc2.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc2.tabBarItem.selectedImage = UIImage(systemName: "magnifyingglass.fill")
        vc3.tabBarItem.image = UIImage(systemName: "bell")
        vc3.tabBarItem.selectedImage = UIImage(systemName: "bell.fill")
        vc4.tabBarItem.image = UIImage(systemName: "envelope")
        vc4.tabBarItem.selectedImage = UIImage(systemName: "envelope.fill")
        
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
    }
}

