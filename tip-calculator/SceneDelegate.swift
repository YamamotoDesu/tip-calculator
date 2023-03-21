//
//  SceneDelegate.swift
//  tip-calculator
//
//  Created by 山本響 on 2023/03/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let vc = CalculaterVC()
        
        window.rootViewController = vc
        self.window = window
        window.makeKeyAndVisible()
    }

}

