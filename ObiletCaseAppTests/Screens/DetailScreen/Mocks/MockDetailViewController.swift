//
//  MockDetailViewController.swift
//  ObiletCaseAppTests
//
//  Created by Burak Gül on 20.08.2024.
//

@testable import ObiletCaseApp

final class MockDetailViewController: DetailViewControllerInterface {
    var invokedSetup : Bool = false
    var invokedSetupCount : Int = 0
    func setup() {
        invokedSetup = true
        invokedSetupCount += 1
    }
    var invokedUpdateViewWith : Bool = false
    var invokedUpdateViewWithCount : Int = 0
    func updateViewWith(_ product: ObiletCaseApp.Product) {
        invokedUpdateViewWith = true
        invokedUpdateViewWithCount += 1
    }
    
    var invokedSetupNavigationBar : Bool = false
    var invokedSetupNavigationBarCount : Int = 0
    func setupNavigationBar() {
        invokedSetupNavigationBar = true
        invokedSetupNavigationBarCount += 1
    }
    
    
}
