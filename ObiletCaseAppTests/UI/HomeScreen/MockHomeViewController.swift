//
//  MockHomeViewController.swift
//  ObiletCaseAppTests
//
//  Created by Burak Gül on 15.08.2024.
//

@testable import ObiletCaseApp

final class MockHomeViewController: HomeViewControllerInterface {
    var collectionViewIsDragging: Bool = false
    
    
    var invokedReloadData : Bool = false
    var invokedReloadDataCount : Int = 0
    func reloadData() {
        invokedReloadData = true
        invokedReloadDataCount += 1
    }
    
    var invokedSetup : Bool = false
    var invokedSetupCount : Int = 0
    func setup() {
        invokedSetup = true
        invokedSetupCount += 1
    }
    
    var invokedSetupNavigationBar : Bool = false
    var invokedSetupNavigationBarCount : Int = 0
    func setupNavigationBar() {
        invokedSetupNavigationBar = true
        invokedSetupNavigationBarCount += 1
    }
    
    var invokedShowNoConnection : Bool = false
    var invokedShowNoConnectionCount : Int = 0
    func showNoConnection() {
         invokedShowNoConnection = true
         invokedShowNoConnectionCount += 1
    }
    
    var invokedHideNoConnection : Bool = false
    var invokedHideNoConnectionCount : Int = 0
    func hideNoConnection() {
        invokedHideNoConnection = true
        invokedHideNoConnectionCount += 1
    }
    
    var invokedBeginRefreshing : Bool = false
    var invokedBeginRefreshingCount : Int = 0
    func beginRefreshing() {
        invokedBeginRefreshing = true
        invokedBeginRefreshingCount += 1
    }  
    
    var invokedEndRefreshing : Bool = false
    var invokedEndRefreshingCount : Int = 0
    func endRefreshing() {
        invokedEndRefreshing = true
        invokedEndRefreshingCount += 1
    }
    

    
    
}
