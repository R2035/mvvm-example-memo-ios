//
//  SceneDelegate.swift
//  Memo
//
//  Created by oe on 2021/10/16.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: UIWindowScene

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBackground
        UINavigationBar.appearance().scrollEdgeAppearance = appearance

        guard let scene = (scene as? UIWindowScene) else {
            return
        }

        let window = UIWindow(windowScene: scene)
        self.window = window
        window.makeKeyAndVisible()

        window.rootViewController = UINavigationController(rootViewController: MemoListViewController())
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}
