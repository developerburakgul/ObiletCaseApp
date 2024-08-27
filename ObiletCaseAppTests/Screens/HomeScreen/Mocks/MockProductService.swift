//
//  MockProductService.swift
//  ObiletCaseAppTests
//
//  Created by Burak Gül on 15.08.2024.
//

@testable import ObiletCaseApp

final class MockProductService: ProductServiceInterface {
    
    var invokedFetchProducts = false
    var invokedFetchProductsCount = 0
    var fetchProductsResult: Result<[Product], Error>?
    
    func fetchProducts(path: ObiletCaseApp.NetworkPath, completion: @escaping (Result<[ObiletCaseApp.Product], Error>) -> ()) {
        invokedFetchProducts = true
        invokedFetchProductsCount += 1
        if let result = fetchProductsResult {
                    completion(result)
                }
    }
    
}
