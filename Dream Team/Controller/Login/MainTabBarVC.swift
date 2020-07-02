//
//  MainTabVC.swift
//  Dream Team
//
//  Created by Student on 5/20/20.
//  Copyright © 2020 Alla Kim. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarVC: UITabBarController, UITabBarControllerDelegate {
   
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self

        tabBar.tintColor = .black

        configure()
    }

    func configure() {
        
            let feed = createNavigationController(viewController: FeedVC(collectionViewLayout: UICollectionViewFlowLayout()), title: "Feed", selectedImage: #imageLiteral(resourceName: "home_selected"), unselectedImage: #imageLiteral(resourceName: "home_unselected"))
            let messages = createNavigationController(viewController: MessagesVC(), title: "Messages", selectedImage: #imageLiteral(resourceName: "send2"), unselectedImage: #imageLiteral(resourceName: "send2"))
            let profile = createNavigationController(viewController: ProfileVC(collectionViewLayout: UICollectionViewFlowLayout()), title: "Profile", selectedImage: #imageLiteral(resourceName: "profile_selected"), unselectedImage: #imageLiteral(resourceName: "profile_unselected"))

            viewControllers = [feed, messages, profile]
        
    }

    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser == nil {
            let loginVC = LoginVC()
            let navController = UINavigationController(rootViewController: loginVC)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: false, completion: nil)
        } else {
            print("USER IS LOGGED IN")
        }
    }

    fileprivate func createNavigationController(viewController: UIViewController, title: String, selectedImage: UIImage, unselectedImage: UIImage) -> UIViewController {
        
        let navigationController = UINavigationController(rootViewController: viewController)
        
        viewController.navigationItem.title = title
        
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = unselectedImage
        navigationController.tabBarItem.selectedImage = selectedImage

        return navigationController
    }
    
}
