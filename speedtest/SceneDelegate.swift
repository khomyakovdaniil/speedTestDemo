//
//  SceneDelegate.swift
//  speedtest
//
//  Created by  Даниил Хомяков on 07.04.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let _ = (scene as? UIWindowScene) else { return }
        
        // Setting the app theme according to user choice
        switch SettingsManager.getTheme() {
        case 1:
            window?.overrideUserInterfaceStyle = .light
        case 2:
            window?.overrideUserInterfaceStyle = .dark
        default:
            return
        }
    }
}

