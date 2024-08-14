//
//  NetworkUtils.swift
//  ObiletCaseApp
//
//  Created by Burak Gül on 12.08.2024.
//

import Foundation
import Alamofire


protocol NetworkPath {
    var urlString : String {get}
}

enum Endpoint : NetworkPath{
    
    
    private var baseURL : String { "https://fakestoreapi.com" }
    
    
    case products
    case categories
    
     var urlString : String {
         
         var endPoint : String
         switch self {
             
         case .products:
             endPoint = "/products"
         case .categories:
             endPoint = "/products/categories"
         }
         return baseURL + endPoint
    }
    
}

enum NetworkType {
    case get,post
    
    func toAlamofire() -> HTTPMethod {
        switch self {
        case .get:
            return .get
        case .post:
            return .post
        }
    }
}
