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
        
        productService = nil
        view = nil
        viewModel = nil
        super.tearDown()
    }
    
    func test_viewDidLoad_InvokeRequiredMethods() {
        // given
        XCTAssertFalse(view.invokedSetup)
        XCTAssertFalse(productService.invokedFetchProducts)
        
        // Prepare expectation
        let expectation = self.expectation(description: "Fetch products should be invoked")
        
        // when
        viewModel.viewDidLoad()
        
        // then
        XCTAssertTrue(view.invokedSetup)
        
        DispatchQueue.main.async {
            XCTAssertEqual(self.productService.invokedFetchProductsCount, 1)
            expectation.fulfill() // Fulfill the expectation after the assertion
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    
    
    func test_viewWillAppear_InvokeRequiredMethods() {
        // given
        XCTAssertFalse(view.invokedSetupNavigationBar)
        
        // when
        viewModel.viewWillAppear()
        
        // then
        XCTAssertEqual(view.invokedSetupNavigationBarCount, 1)
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
        
        DispatchQueue.main.async {
            XCTAssertTrue(self.productService.invokedFetchProducts)
            XCTAssertEqual(self.view.invokedEndRefreshingCount ,1)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    
    func test_ApplyFilters_WithCategory() {
        // given
        let categoryA = Category.electronics
        let categoryB = Category.jewelery
        
        let product1 = Product.mockProduct(title: "Product1",category: categoryA)
        let product2 = Product.mockProduct(title: "Product2",category: categoryB)
        let product3 = Product.mockProduct(title: "Product3",category: categoryA)
        
        productService.fetchProductsResult = .success([product1,product2,product3])
        viewModel.fetchProducts()
        
        // when
        viewModel.didSelectCategory(categoryA)
        
        // then
        XCTAssertEqual(viewModel.countOfProducts, 2)
        XCTAssertEqual(viewModel.getProduct(indexPath: IndexPath(row: 0, section: 0)).title, "Product1")
        XCTAssertEqual(viewModel.getProduct(indexPath: IndexPath(row: 1, section: 0)).title, "Product3")
    }
    
    
    
    
}
