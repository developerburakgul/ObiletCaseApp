//
//  HomeViewModelTests.swift
//  ObiletCaseAppTests
//
//  Created by Burak Gül on 15.08.2024.
//

import XCTest
@testable import ObiletCaseApp



final class HomeViewModelTests : XCTestCase {
    private var viewModel : HomeViewModel!
    private var productService : MockProductService!
    private var view : MockHomeViewController!
    
    override  func setUp() {
        super.setUp()
        view = MockHomeViewController()
        productService = .init()
        viewModel = HomeViewModel(productService: productService)
        viewModel.view = view
    }
    
    override  func tearDown() {
        super.tearDown()
        productService = nil
        view = nil
        viewModel = nil
    }
    
    func test_viewDidLoad_FetchProductsSuccess() {
        // given
        XCTAssertFalse(view.invokedSetup)
        XCTAssertFalse(productService.invokedFetchProducts)
        
        // prepation
        let expectation = self.expectation(description: "Fetching products")
        let mockProduct = Product.mockProduct()
        productService.fetchProductsResult = .success([mockProduct])
        
        // when
        viewModel.viewDidLoad()
        
        // then
        XCTAssertTrue(view.invokedSetup)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.productService.invokedFetchProducts)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_viewdDidLoad_FetchProductsFail(){
        // given
        XCTAssertFalse(view.invokedSetup)
        XCTAssertFalse(productService.invokedFetchProducts)
        
        // prepation
        let expectation = self.expectation(description: "Fetching products")
        let mockProduct = Product.mockProduct()
        productService.fetchProductsResult = .failure(NSError())
        
        // when
        viewModel.viewDidLoad()
        
        // then
        XCTAssertTrue(view.invokedSetup)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(self.productService.invokedFetchProductsCount,1)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func test_viewWillAppear_InvokeRequiredMethods() {
        // given
        XCTAssertFalse(view.invokedSetupNavigationBar)
        
        // when
        viewModel.viewWillAppear()
        
        // then
        XCTAssertEqual(view.invokedSetupNavigationBarCount, 1)
    }
    
    func test_TextDidChangeWith_InvokesRequiredMethods(){
        
        // given
        XCTAssertFalse(view.invokedReloadData)
        
        // when
        viewModel.textDidChangeWith("searchText")
        
        // then
        XCTAssertEqual(view.invokedReloadDataCount, 1)
    }
    
    func test_SearchBarCancelButtonClicked_InvokesRequiredMethods() {
        // given
        XCTAssertFalse(view.invokedReloadData)
        
        // when
        viewModel.searchBarCancelButtonClicked()
        
        // then
        XCTAssertEqual(view.invokedReloadDataCount, 1)
    }
    
    func test_PulledDownRefreshControl_InvokesRequiredMethods() {
        // given
        XCTAssertFalse(view.invokedBeginRefreshing)
        XCTAssertFalse(productService.invokedFetchProducts)
        XCTAssertFalse(view.invokedEndRefreshing)
        
        // prepation
        let expectation = self.expectation(description: "Pulled Down")
        
        // when
        viewModel.pulledDownRefreshControl()
        
        // then
        XCTAssertTrue(view.invokedBeginRefreshing)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.productService.invokedFetchProducts)
            XCTAssertEqual(self.view.invokedEndRefreshingCount ,1)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        
        
    }
    

    
    
    
    
    
    
}
