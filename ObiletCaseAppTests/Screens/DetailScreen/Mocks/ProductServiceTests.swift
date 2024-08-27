//
//  ProductServiceTests.swift
//  ObiletCaseAppTests
//
//  Created by Burak Gül on 20.08.2024.
//

import XCTest
@testable import ObiletCaseApp

final class ProductServiceTests: XCTestCase {
    private var networkManager: MockNetworkManager!
    private var productService : ProductService!
    override  func setUp() {
        super.setUp()
        networkManager = .init()
        productService = .init(networkManager: networkManager)
    }
    
    override  func tearDown() {
        networkManager = nil
        productService = nil
        super.tearDown()
    }
    
    func test_FetchProducts_SuccesfullResponse() {
        // given
        let expectedProducts = [Product.mockProduct()]
        networkManager.resultToReturn = .success(expectedProducts)
        XCTAssertEqual(networkManager.requestCalledCount, 0)
        
        var fetchedProducts: [Product]?
        var fetchedError: Error?
        
        // When
        productService.fetchProducts(path: Endpoint.products) { result in
            switch result {
            case .success(let products):
                fetchedProducts = products
            case .failure(let error):
                fetchedError = error
            }
        }
        // then
        XCTAssertEqual(networkManager.requestCalledCount, 1)
        if let fetchedProducts = fetchedProducts {
                    XCTAssertEqual(fetchedProducts, expectedProducts)
                }
        XCTAssertNil(fetchedError)
    }
    
    func test_FetchProducts_FailureResponse() {
        // given
        let expectedError = NSError(domain: "test", code: 404, userInfo: nil)
        networkManager.resultToReturn = .failure(expectedError)
        XCTAssertEqual(networkManager.requestCalledCount, 0)
        
        var fetchedProducts: [Product]?
        var fetchedError: Error?
        
        // When
        productService.fetchProducts(path: Endpoint.products) { result in
            switch result {
            case .success(let products):
                fetchedProducts = products
            case .failure(let error):
                fetchedError = error
            }
        }
        // then
        XCTAssertEqual(networkManager.requestCalledCount, 1)
        if let fetchedError = fetchedError {
            XCTAssertEqual(fetchedError as NSError, expectedError)
                }
        XCTAssertNil(fetchedError)
    }
}
