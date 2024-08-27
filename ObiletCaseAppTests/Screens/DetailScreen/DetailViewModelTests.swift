//
//  DetailViewModelTests.swift
//  ObiletCaseAppTests
//
//  Created by Burak Gül on 20.08.2024.
//

import XCTest
@testable import ObiletCaseApp

final class DetailViewModelTests: XCTestCase {
    
    private var viewModel: DetailViewModel!
    private var view : MockDetailViewController!
    private var product : Product!
    
    
    
    override  func setUp() {
        super.setUp()
        view = .init()
        product = Product.mockProduct()
        viewModel = DetailViewModel(product: product)
        viewModel.view = view
    }
    
    override  func tearDown() {
        view = nil
        product = nil
        viewModel = nil
        super.tearDown()
    }
    
    func test_ViewDidLoad_ShouldInvokesRequiredMethods(){
        // given
        XCTAssertFalse(view.invokedSetup)
        XCTAssertFalse(view.invokedUpdateViewWith)
        
        // when
        viewModel.viewDidLoad()
        
        // then
        XCTAssertEqual(view.invokedSetupCount, 1)
        XCTAssertEqual(view.invokedUpdateViewWithCount, 1)
    }
    
    func test_ViewWillAppear_ShouldInvokeRequiredMethods(){
        // given
        XCTAssertFalse(view.invokedSetupNavigationBar)
        
        // when
        viewModel.viewWillAppear()
        
        // then
        XCTAssertEqual(view.invokedSetupNavigationBarCount, 1)
    }
    
    func test_UpdateView_ShouldInvokesRequiredMethods() {
        // given
        XCTAssertFalse(view.invokedUpdateViewWith)
        
        // when
        viewModel.updateView()
        
        // then
        XCTAssertEqual(view.invokedUpdateViewWithCount, 1)
    }
    
    
}
