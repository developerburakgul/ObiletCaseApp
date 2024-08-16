//
//  Product+Mock.swift
//  ObiletCaseAppTests
//
//  Created by Burak Gül on 15.08.2024.
//

@testable import ObiletCaseApp

extension Product {
    static func mockProduct(
        id: Int = 1,
        title: String = "Mock Product",
        price: Double = 99.99,
        description: String = "This is a mock product description.",
        category: Category = Category.jewelery,
        image: String = "https://example.com/image.jpg",
        rating: Rating = Rating(rate: 4.5, count: 100)
    ) -> Product {
        return Product(
            id: id,
            title: title,
            price: price,
            description: description,
            category: category,
            image: image,
            rating: rating
        )
    }
}




