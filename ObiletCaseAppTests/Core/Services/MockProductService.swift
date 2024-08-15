//
//  MockProductService.swift
//  ObiletCaseAppTests
//
//  Created by Burak Gül on 15.08.2024.
//

@testable import ObiletCaseApp

final class MockProductService: ProductServicing {
    
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
    
    var invokedFetchCategories = false
        var invokedFetchCategoriesCount = 0
    var fetchCategoriesResult: Result<[String], Error>?
    func fetchCategories(path: ObiletCaseApp.NetworkPath, completion: @escaping (Result<[String], Error>) -> ()) {
        invokedFetchCategories = true
        invokedFetchCategoriesCount += 1
        if let result = fetchCategoriesResult {
            completion(result)
        }
    }
    
    
}
