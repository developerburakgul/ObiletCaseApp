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
    func pulledDownRefreshControl()
    func didSelectCategory(_ category : Category?)
    
}

final class HomeViewModel {
    weak var view : HomeViewControllerInterface?
    private let productService : ProductServicing
    private var products : [Product] = []
    private var categories: [String] = []
    private var showProducts : [Product] = []
    
    
    private var selectedCategory: Category?
    private var currentSearchText: String = ""
    
    
    /// this flag is going to help me because when i pull to refresh , again i can pull to refresh and this creates many operation
    private var isFetching = false
    
    
    var countOfProducts : Int {
        showProducts.count
    }
    //MARK: - Init
    init(productService: ProductServicing) {
        self.productService = productService
    }
    
    //MARK: - Public Functions
    
    func fetchProducts() {
        
        guard !isFetching else { return } // if there is fetch operation , dont start
        isFetching = true
        DispatchQueue.global(qos: .background).async {
            self.productService.fetchProducts(path: Endpoint.products) { result in
                self.isFetching = false // Reset the flag when the operation is complete
                switch result {
                case .success(let data):
                    self.products = data
                    self.applyFilters()
                    DispatchQueue.main.async {
                        self.view?.hideNoConnection() // Hide the noConnectionImageView on successful data fetch
                        self.view?.reloadData() // Reload the collection view with new data
                    }
                case .failure(let error):
                    self.showProducts = []
                    DispatchQueue.main.async {
                        self.view?.showNoConnection() // Show noConnectionImageView if data fetch fails
                        self.view?.reloadData()
                    }
                }
            }
        }
        
        
    }
    
    func getProduct(indexPath : IndexPath) -> Product {
        showProducts[indexPath.row]
    }
    
    
    func applyFilters() {
        var tempArray = products
        if let selectedCategory = selectedCategory {
            tempArray = tempArray.filter({ product in
                product.category == selectedCategory
            })
        }
        
        if !currentSearchText.isEmpty {
            tempArray = tempArray.filter({ product in
                product.title.contains(currentSearchText) || product.description.contains(currentSearchText)
            })
        }
        showProducts = tempArray
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
        self.currentSearchText = searchText
        applyFilters()
        view?.reloadData()
    }
    
    func searchBarCancelButtonClicked() {
        showProducts = products
        view?.reloadData()
    }
    
    func pulledDownRefreshControl() {
        view?.beginRefreshing()
        fetchProducts()
        DispatchQueue.main.async {
            self.view?.endRefreshing()
        }
        
    }
    
    func didSelectCategory(_ category: Category?) {
        selectedCategory = category
        applyFilters()
        view?.reloadData()
    }
    
}
