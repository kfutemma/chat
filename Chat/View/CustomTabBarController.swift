//
//  CustomTabBarController.swift
//  Chat
//
//  Created by Kaique Futemma on 10/07/18.
//  Copyright © 2018 Kaique Futemma. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ativação da tela de conversas como principal do app
        let layout = UICollectionViewFlowLayout()
        let messageController = MessageController(collectionViewLayout: layout)
        let recentMessagesNavController = UINavigationController(rootViewController: messageController)
        recentMessagesNavController.tabBarItem.title = "Minhas conversas"
        recentMessagesNavController.tabBarItem.image = UIImage(named: "talking_icon")
        
        let profileController = ProfileController()
        let navController = UINavigationController(rootViewController: profileController)
        navController.tabBarItem.title = "Meu Perfil"
        navController.tabBarItem.image = UIImage(named: "icons8-old-man-50")
        
        viewControllers = [recentMessagesNavController, navController]
    }
}

