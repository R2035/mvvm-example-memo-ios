//
//  AppDelegate.swift
//  Memo
//
//  Created by oe on 2021/10/16.
//

import MemoCore
import Swinject
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private static let container = Container()

    static let assembler: Assembler = {
        let assembler = Assembler(container: container)
        assembler.apply(assemblies: [
            AppAssembly(),
            CoreAssembly(),
        ])
        return assembler
    }()

    // MARK: UIApplicationDelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}
