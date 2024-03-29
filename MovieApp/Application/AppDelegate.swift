//
//  AppDelegate.swift
//  MovieApp
//
//  Created by Pyo on 2024/03/29.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate,
                   RootFlowDIContainerDependencies
{
    internal var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        let rootDI = RootDIContainer(dependencies: self)
        let root = rootDI.makeRootviewController()
        let navigationController = UINavigationController(rootViewController: root)
        navigationController.setNavigationBarHidden(true, animated: false)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}



public protocol RootFlowDIContainerDependencies {
}

final class RootDIContainer : 
    RootViewModelDependencies,
    RootViewControllerDependencies
{
    
    internal let dependencies : RootFlowDIContainerDependencies
    
    init(dependencies: RootFlowDIContainerDependencies) {
        self.dependencies = dependencies
    }
}

extension RootDIContainer{
    func makeRootviewController() -> RootViewController{
        let viewModel = RootViewModel(dependencies: self)
        return RootViewController(dependencies: self, viewModel: viewModel)
    }
}

