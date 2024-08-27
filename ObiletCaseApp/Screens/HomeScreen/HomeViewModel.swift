//
//  HomeViewModel.swift
//  ObiletCaseApp
//
//  Created by Burak Gül on 12.08.2024.
//

import Foundation


//MARK: - HomeViewModelInterface
protocol HomeViewModelInterface {
    var view: HomeViewControllerInterface? { get set }
    var countOfProduct: Int { get }
    func viewDidLoad()
    func viewWillAppear()
    func textDidChangeWith(_ searchText : String)
    func searchBarCancelButtonClicked()
    func pulledDownRefreshControl()
    func didSelectCategory(_ category : Category?)
    func didUnSelectCategory(_ category : Category?)
    func getProduct(indexPath: IndexPath) -> Product
    
}

final class HomeViewModel {
    weak var view : HomeViewControllerInterface?
    private let productService : ProductServiceInterface
    private(set) var products : [Product] = []
    private var showProducts : [Product] = []
    
    private var selectedCategory: Category?
    private var currentSearchText: String = ""
    
    
    /// this flag is going to help me because when i pull to refresh , again i can pull to refresh and this creates many operation
    private var isFetching = false

    //MARK: - Init
    init(productService: ProductServiceInterface) {
        self.productService = productService
    }
    
    //MARK: - Public Functions
    
    private func fetchProducts() {
        
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
                case .failure(_):
                    self.showProducts = []
                    DispatchQueue.main.async {
                        self.view?.showNoConnection() // Show noConnectionImageView if data fetch fails
                        self.view?.reloadData()
                    }
                }
            }
        }
    }
    
    
    private func applyFilters() {
        showProducts = products.filter({ product in
            
            if selectedCategory == nil && !currentSearchText.isEmpty {
                return product.title.contains(currentSearchText) || product.description.contains(currentSearchText)
            }
            else if selectedCategory == nil && currentSearchText.isEmpty {
                return true
            }
            else if selectedCategory == product.category  && currentSearchText.isEmpty{
                return true
            }
            else if selectedCategory == product.category && !currentSearchText.isEmpty {
                return product.title.contains(currentSearchText) || product.description.contains(currentSearchText)
            }
            return false
            
           
        })
    }
}



//MARK: - HomeViewModelInterface
extension HomeViewModel: HomeViewModelInterface {

    var countOfProduct: Int {
        showProducts.count
    }
    
    func viewDidLoad() {
        view?.setup()
        fetchProducts()
    }
    
    func viewWillAppear() {
        view?.setupNavigationBar()
    }
    
    func textDidChangeWith(_ searchText: String) {
        currentSearchText = searchText
        applyFilters()
        view?.reloadData()
    }
    
    func searchBarCancelButtonClicked() {
        selectedCategory = nil
        showProducts = products
        applyFilters()
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
    func didUnSelectCategory(_ category: Category?) {
        selectedCategory = nil
        applyFilters()
        view?.reloadData()
    }
    
    func getProduct(indexPath : IndexPath) -> Product {
        showProducts[indexPath.row]
    }
    
}
