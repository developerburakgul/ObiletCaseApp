//
//  HomeViewModel.swift
//  ObiletCaseApp
//
//  Created by Burak Gül on 12.08.2024.
//

import Foundation


//MARK: - HomeViewModelInterface
protocol HomeViewModelInterface {
    func viewDidLoad()
    func viewWillAppear()
    func textDidChangeWith(_ searchText : String)
    func searchBarCancelButtonClicked()
    
}

final class HomeViewModel {
    weak var view : HomeViewControllerInterface?
    private let productService : ProductServicing
    private var products : [Product] = []
    private var categories: [String] = []
    private var showProducts : [Product] = []
    
    
    var countOfProducts : Int {
        showProducts.count
    }
    //MARK: - Init
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
                self.view?.hideNoConnection()
                self.view?.reloadData()
            case .failure(let error):
                self.view?.showNoConnection()
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
            case .failure(let failure):
                fatalError("errorr")
            }
        }
        
    }
    
    func getCategories() -> [String] {
        return categories
    }
    
    
    
    /// Filters the product list based on the search text.
    /// Category filter requires an exact match, while title and description filters check for keyword containment.
    /// - Parameter text: User's searchText
    func filterProductsWith(_ text : String) {
        // If the search text is empty, show all products
        if text.isEmpty {
            showProducts = products
            return
        }
        // Split the search text into keywords for filtering
        let keywords = text.lowercased().split(separator: " ")
        
        var tempProductArray: [Product] = []
        
        // Step 1: Filter products by exact match in the category
        let categoryMatches = products.filter { product in
            for keyword in keywords {
                // Check for exact match between product category and keyword
                if product.category.lowercased() == keyword {
                    return true
                }
            }
            return false
        }
        tempProductArray.append(contentsOf: categoryMatches)
        
        // Step 2: Filter products by keyword containment in the title
        let titleMatches = products.filter { product in
            // Exclude products that are already matched in the category filter
            if categoryMatches.contains(where: { $0 == product }) {
                return false
            }
            for keyword in keywords {
                // Check if the title contains any of the keywords
                if product.title.lowercased().contains(keyword) {
                    return true
                }
            }
            return false
        }
        tempProductArray.append(contentsOf: titleMatches)
      
        // Step 3: Filter products by keyword containment in the description
        let descriptionMatches = products.filter { product in
            // Exclude products that are already matched in the category or title filters
            if categoryMatches.contains(where: { $0 == product }) || titleMatches.contains(where: { $0 == product }) {
                return false
            }
            for keyword in keywords {
                // Check if the description contains any of the keywords
                if product.description.lowercased().contains(keyword) {
                    return true
                }
            }
            return false
        }
        tempProductArray.append(contentsOf: descriptionMatches)
        
        // Update the showProducts array with the filtered results
        showProducts = tempProductArray
    }


}



//MARK: - HomeViewModelInterface Implementation
extension HomeViewModel : HomeViewModelInterface {
    func viewDidLoad() {
        view?.setup()
        fetchProducts()
    }
    
    func viewWillAppear() {
        view?.setupNavigationBar()
    }
    
    func textDidChangeWith(_ searchText: String) {
        self.filterProductsWith(searchText)
        view?.reloadData()
    }
    
    func searchBarCancelButtonClicked() {
        showProducts = products
        view?.reloadData()
    }
    
}
