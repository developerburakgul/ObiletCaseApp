//
//  ProductService.swift
//  ObiletCaseApp
//
//  Created by Burak Gül on 12.08.2024.
//

import Foundation


protocol ProductServicing {
    func fetchProducts(path : NetworkPath,completion : @escaping (Result<[Product],Error>)->())
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
}


