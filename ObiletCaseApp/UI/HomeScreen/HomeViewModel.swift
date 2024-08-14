//
//  HomeViewModel.swift
//  ObiletCaseApp
//
//  Created by Burak Gül on 12.08.2024.
//

import Foundation

protocol HomeViewModelOutput :AnyObject {
    func collectionViewReloadData()
}

class HomeViewModel {
    weak var output : HomeViewModelOutput?
    
    private let productService : ProductServicing
    
    
    private var products : [Product] = []
    private var categories: [String] = []
    private var showProducts : [Product] = []
    
    
    var countOfProducts : Int {
        showProducts.count
    }
    
    init(productService: ProductServicing) {
        self.productService = productService
    }
    
    //MARK: - Public Functions
    func fetchProducts() {
        productService.fetchProducts(path: Endpoint.products) { result in
            switch result {
            case .success(let data):
                self.products = data
                self.showProducts = data
                self.output?.collectionViewReloadData()
            case .failure(let error):
                dump(error)
            }
        }
    }
    
    func getProduct(indexPath : IndexPath) -> Product {
        showProducts[indexPath.row]
    }
    
    func fetchCategories() {
        
        productService.fetchCategories(path: Endpoint.categories) { result in
            switch result {
            case .success(let data):
                self.categories = data
                //                self.output?.updateFilterButtons(with: data)
            case .failure(let failure):
                fatalError("errorr")
            }
        }
        
    }
    
    func getCategories() -> [String] {
        return categories
    }
    
    func filterProductsBy(_ category :String) {
        showProducts = products.filter({ product in
            return product.category == category
        })
        
    }
    
    func filterProductsWith(_ text : String) {
        
        
        if text.isEmpty {
            showProducts = products
            output?.collectionViewReloadData()
            return
        }
        
        
        let keywords = text.lowercased().split(separator: " ")
        
        var tempProductArray: [Product] = []
        
        // Önce category'de eşleşenleri ekle
        let categoryMatches = products.filter { product in
            for keyword in keywords {
                if product.category.lowercased().contains(keyword) {
                    return true
                }
            }
            return false
        }
        tempProductArray.append(contentsOf: categoryMatches)
        
        // Sonra title'da eşleşenlerden category'de bulunmayanları ekle
        let titleMatches = products.filter { product in
            if categoryMatches.contains(where: { $0 == product }) {
                return false
            }
            for keyword in keywords {
                if product.title.lowercased().contains(keyword) {
                    return true
                }
            }
            return false
        }
        tempProductArray.append(contentsOf: titleMatches)
        
        // En son description'da eşleşenlerden category veya title'da bulunmayanları ekle
        let descriptionMatches = products.filter { product in
            if categoryMatches.contains(where: { $0 == product }) || titleMatches.contains(where: { $0 == product }) {
                return false
            }
            for keyword in keywords {
                if product.description.lowercased().contains(keyword) {
                    return true
                }
            }
            return false
        }
        tempProductArray.append(contentsOf: descriptionMatches)
        
        showProducts = tempProductArray
        
        output?.collectionViewReloadData()
    }
    
     func searchBarCancelButtonClicked() {
        showProducts = products
        output?.collectionViewReloadData()
    }
    
    
}
