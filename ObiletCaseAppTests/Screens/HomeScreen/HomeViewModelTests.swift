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
        view = .init()
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
    
    
    
    func test_CountOfProduct()  {
        // given
        XCTAssertEqual(viewModel.countOfProduct, 0)
        
        // prepation
        let expectation = self.expectation(description: "Fetch products should be invoked")
        
        productService.fetchProductsResult = .success([Product.mockProduct(),Product.mockProduct(id: 2,title: "Another")])
        // when
        viewModel.viewDidLoad()
        
        // then
        DispatchQueue.main.async {
            XCTAssertEqual(self.viewModel.countOfProduct, 2)
            expectation.fulfill() // Fulfill the expectation after the assertion
        }
        waitForExpectations(timeout: 1, handler: nil)
        
    }
    
    func test_ViewDidLoad_ShouldInvokesRequiredMethods(){
        // given
        XCTAssertFalse(view.invokedSetup)
        XCTAssertFalse(productService.invokedFetchProducts)
        
        // prepation
        let expectation = self.expectation(description: "ViewDidLoad Invokes Required All Methods")
        
        
        // when
        viewModel.viewDidLoad()
        // then
        XCTAssertEqual(view.invokedSetupCount, 1)
        DispatchQueue.main.async {
            XCTAssertEqual(self.productService.invokedFetchProductsCount, 1)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
        
    }
    func test_ViewDidLoad_FetchProductsSuccess_ShouldInvokeViewMethods(){
        // given
        productService.fetchProductsResult = .success([Product.mockProduct(),
                                                       Product.mockProduct(),
                                                       Product.mockProduct()
                                                      ])
        
        // preparation
        let expectation = self.expectation(description: "FetchProducts Success")
        
        // when
        viewModel.viewDidLoad()
        
        // then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.view.invokedHideNoConnectionCount, 1)
            XCTAssertEqual(self.view.invokedReloadDataCount, 1)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        
        
    }
    
    
    func test_ViewDidLoad_FetchProductsSuccess_ShouldApplyFilters(){
        // given
        productService.fetchProductsResult = .success([
            Product.mockProduct(title: "Title1",category: .electronics),
            Product.mockProduct(title: "Title2",category: .jewelery),
            Product.mockProduct(title: "Title3",category: .electronics)
            
        ])
        
        // prepation
        let expectation = self.expectation(description: "Apply Filters")
        
        // when
        viewModel.didSelectCategory(.electronics)
        viewModel.viewDidLoad()
        
        // then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            XCTAssertEqual(self.viewModel.countOfProduct, 2)
            XCTAssertEqual(self.viewModel.getProduct(indexPath: .init(row: 0, section: 0)).title, "Title1")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
        
    }
    
    func test_ViewDiLoad_FetchProductsFailure_ShouldInvokeViewMethods(){
        // given
        productService.fetchProductsResult = .failure(NSError())
        
        // preparation
        let expectation = self.expectation(description: "FetchProducts failure")
        
        // when
        viewModel.viewDidLoad()
        
        // then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.view.invokedShowNoConnectionCount, 1)
            XCTAssertEqual(self.view.invokedReloadDataCount, 1)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    
    func test_ViewWillAppear_ShouldInvokeViewMethods(){
        // given
        XCTAssertFalse(view.invokedSetupNavigationBar)
        
        // when
        viewModel.viewWillAppear()
        
        // then
        XCTAssertEqual(view.invokedSetupNavigationBarCount, 1)
    }
    
    func test_TextDidChangeWith_EmptySearchText_ShouldShowAllProducts() {
        // given
        productService.fetchProductsResult = .success([
            Product.mockProduct(title: "Title1"),
            Product.mockProduct(title: "Title2"),
            Product.mockProduct(title: "Title3")
        ])
        // when
        viewModel.viewDidLoad()
        viewModel.textDidChangeWith("")
        // then
        XCTAssertEqual(viewModel.countOfProduct, 3)
        XCTAssertEqual(view.invokedReloadDataCount,1)
    }
    
    func test_TextDidChangeWith_ValidSearchText_ShouldFilterProductsCorrectly() {
        // given
        let product1 = Product.mockProduct(title: "Apple iPhone")
        let product2 = Product.mockProduct(id: 2,title: "Samsung Galaxy")
        productService.fetchProductsResult = .success([product1,product2])
        
        // prepation
        let expectation = self.expectation(description: "Filter Products")
        viewModel.viewDidLoad()
        
        // when
        viewModel.textDidChangeWith("Apple")
        
        // then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewModel.countOfProduct, 1)
            XCTAssertEqual(self.viewModel.getProduct(indexPath: IndexPath(row: 0, section: 0)).title, "Apple iPhone")
            XCTAssertEqual(self.view.invokedReloadDataCount,2)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    func test_TextDidChangeWith_InvalidSearchText_ShouldFilterProductsCorrectly() {
        // given
        let product1 = Product.mockProduct(title: "Apple iPhone")
        let product2 = Product.mockProduct(id: 2,title: "Samsung Galaxy")
        productService.fetchProductsResult = .success([product1,product2])
        
        // prepation
        let expectation = self.expectation(description: "Filter Products noncorrectly")
        viewModel.viewDidLoad()
        
        // when
        viewModel.textDidChangeWith("Nokia")
        
        // then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewModel.countOfProduct, 0)
            XCTAssertEqual(self.view.invokedReloadDataCount,2)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    
    func test_TextDidChangeWith_SearchTextAndCategory_ShouldFilterProductsByTextAndCategory() {
        // given
        let product1 = Product.mockProduct(id: 1,title: "iPhone",category: .electronics)
        let product2 = Product.mockProduct(id: 2,title: "Samsung",category: .electronics)
        let product3 = Product.mockProduct(id: 1,title: "T-Shirt",category: .menSClothing)
        let product4 = Product.mockProduct(id: 1,title: "Shoes",category: .menSClothing)
        productService.fetchProductsResult = .success([product1,product2,product3,product4])
        
        // prepation
        let expectation = self.expectation(description: "Text and Category filter")
        viewModel.viewDidLoad()
        viewModel.didSelectCategory(.electronics)
        
        // when
        viewModel.textDidChangeWith("iPhone")
        
        // then
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1){
            XCTAssertEqual(self.viewModel.countOfProduct, 1)
            XCTAssertEqual(self.viewModel.getProduct(indexPath: .init(row: 0, section: 0)).title,"iPhone")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        
    }
    
    func test_SearchBarButtonClicked_ShouldInvokesRequiredMethods(){
        // Given
        productService.fetchProductsResult = .success([Product.mockProduct(),
                                                       Product.mockProduct(id: 2, title: "Another")])
        // prepation
        let viewDidLoadExpectation = self.expectation(description: "ViewDidLoad ReloadData")
        let searchBarCancelExpectation = self.expectation(description: "SearchBarCancel ReloadData")
        
        // when
        viewModel.viewDidLoad()
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.view.invokedReloadDataCount, 1)
            viewDidLoadExpectation.fulfill()
        }
        wait(for: [viewDidLoadExpectation],timeout: 1)
        
        
        // when
        viewModel.searchBarCancelButtonClicked()
        
        // then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            XCTAssertEqual(self.viewModel.countOfProduct, 2)
            XCTAssertEqual(self.view.invokedReloadDataCount, 2)
            searchBarCancelExpectation.fulfill()
        }
        
        wait(for: [searchBarCancelExpectation], timeout: 1)
        
    }
    
    
    func test_PulledDownRefreshControl_ShouldInvokesRequiredMethods() {
        // given
        XCTAssertEqual(view.invokedBeginRefreshingCount, 0)
        XCTAssertEqual(productService.invokedFetchProductsCount, 0)
        XCTAssertEqual(view.invokedEndRefreshingCount, 0)
        
        // prepation
        let expectation = self.expectation(description: "Pulled Down")
        
        // when
        viewModel.pulledDownRefreshControl()
        
        // then
        XCTAssertEqual(view.invokedBeginRefreshingCount, 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            XCTAssertEqual(self.productService.invokedFetchProductsCount, 1)
            XCTAssertEqual(self.view.invokedEndRefreshingCount, 1)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1,handler: nil)
    }
    
    func test_DidSelectCategory_ShouldFilterProductsBySelectedCategory() {
        // given
        let product1 = Product.mockProduct(id: 1,title: "iPhone",category: .electronics)
        let product2 = Product.mockProduct(id: 2,title: "Samsung",category: .electronics)
        let product3 = Product.mockProduct(id: 1,title: "T-Shirt",category: .menSClothing)
        let product4 = Product.mockProduct(id: 1,title: "Shoes",category: .menSClothing)
        productService.fetchProductsResult = .success([product1,product2,product3,product4])
        
        // prepation
        let expectation = self.expectation(description: "Did Select category")
        viewModel.viewDidLoad()
        
        // when
        viewModel.didSelectCategory(.electronics)
        
        // then
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1){
            XCTAssertEqual(self.viewModel.countOfProduct, 2)
            XCTAssertEqual(self.view.invokedReloadDataCount, 2)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    func test_DidUnSelectCategory_ShouldShowAllProducts() {
        // given
        let product1 = Product.mockProduct(id: 1,title: "iPhone",category: .electronics)
        let product2 = Product.mockProduct(id: 2,title: "Samsung",category: .electronics)
        let product3 = Product.mockProduct(id: 1,title: "T-Shirt",category: .menSClothing)
        let product4 = Product.mockProduct(id: 1,title: "Shoes",category: .menSClothing)
        productService.fetchProductsResult = .success([product1,product2,product3,product4])
        
        // prepation
        let expectation = self.expectation(description: "Did Select category")
        viewModel.viewDidLoad()
        
        // when
        viewModel.didSelectCategory(nil)
        
        // then
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1){
            XCTAssertEqual(self.viewModel.countOfProduct, 4)
            XCTAssertEqual(self.viewModel.getProduct(indexPath: .init(row: 0, section: 0)).title, product1.title)
            XCTAssertEqual(self.view.invokedReloadDataCount, 2)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func test_GetProduct_ShouldReturnCorrectProductForGivenIndexPath(){
        // given
        XCTAssertEqual(viewModel.countOfProduct, 0)
        
        // prepation
        let expectation = self.expectation(description: "Index path")
        let product1 = Product.mockProduct(title: "Apple iPhone")
        let product2 = Product.mockProduct(id: 2, title: "Samsung Galaxy")
        productService.fetchProductsResult = .success([product1, product2])
        viewModel.viewDidLoad()
        
        // When & Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let returnProduct1 = self.viewModel.getProduct(indexPath: IndexPath(row: 0, section: 0))
            let returnProduct2 = self.viewModel.getProduct(indexPath: IndexPath(row: 1, section: 0))
            
            XCTAssertEqual(self.viewModel.countOfProduct, 2)
            XCTAssertEqual(returnProduct1, product1)
            XCTAssertEqual(returnProduct2, product2)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
    
    
    
    
    
    
}
