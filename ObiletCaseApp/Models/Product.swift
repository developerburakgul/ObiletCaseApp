//
//  Product.swift
//  ObiletCaseApp
//
//  Created by Burak Gül on 12.08.2024.
//

import Foundation


struct Rating: Codable {
    let rate: Double
    let count: Int
}

// MARK: - Product
struct Product: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: Category
    let image: String
    let rating: Rating
}


enum Category: String, Codable,CaseIterable {
    case electronics = "electronics"
    case jewelery = "jewelery"
    case menSClothing = "men's clothing"
    case womenSClothing = "women's clothing"
}


extension Product : Equatable {
    static func ==(lhs: Product, rhs: Product) -> Bool {
            return lhs.id == rhs.id
        }
}
