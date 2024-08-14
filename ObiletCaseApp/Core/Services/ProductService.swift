//
//  ProductService.swift
//  ObiletCaseApp
//
//  Created by Burak Gül on 12.08.2024.
//

import Foundation


protocol ProductServicing {
    func fetchProducts(path : NetworkPath,completion : @escaping (Result<[Product],Error>)->())
    func fetchCategories(path : NetworkPath,completion : @escaping (Result<[String],Error>)->())
}

class ProductService  : ProductServicing {

    
    //MARK: - Private Attribute
    private let networkManager : NetworkManaging
    
    //MARK: - Init
    init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
    }
    
    func fetchProducts(path : NetworkPath,completion : @escaping (Result<[Product],Error>)->()) {
        networkManager.request(path, decodeToType: [Product].self, method: .get) { result in
            completion(result)
        }
    }
    
    func fetchCategories(path: NetworkPath, completion: @escaping (Result<[String], Error>) -> ()) {
        networkManager.request(path, decodeToType: [String].self, method: .get) { result in
            completion(result)
        }
    }
    
   
}


