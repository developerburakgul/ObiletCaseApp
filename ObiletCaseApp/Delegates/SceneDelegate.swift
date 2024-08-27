//
//  SceneDelegate.swift
//  ObiletCaseApp
//
//  Created by Burak Gül on 12.08.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        let networkManager : NetworkManaging = AFNetworkManager()
        let productService : ProductServiceInterface = ProductService(networkManager: networkManager)
        let homeViewModel = HomeViewModel(productService: productService)
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        window?.rootViewController = UINavigationController(rootViewController: homeViewController)
        window?.makeKeyAndVisible()
    }


}

