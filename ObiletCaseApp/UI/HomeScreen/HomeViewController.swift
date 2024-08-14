//
//  ViewController.swift
//  ObiletCaseApp
//
//  Created by Burak Gül on 12.08.2024.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    
    
    private var viewModel : HomeViewModel
    
    //MARK: - UI Components
    private var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    private var searchController : UISearchController = {
        let searchController : UISearchController = UISearchController()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        
        return searchController
    }()



    
    //MARK: - Init Functions
    init(viewModel : HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.output = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        viewModel.fetchProducts()
        viewModel.fetchCategories()
        view.backgroundColor = .systemBackground
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    //MARK: - Setup Functions
    private func setup()  {
        setupNavigationBar()
        setupCollectionView()
        setupDelegates()
    }

    private func setupNavigationBar(){
        self.navigationItem.title = "Home Screen"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.searchController = searchController
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.label]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        
        
    }
    

    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupDelegates()  {
        collectionView.delegate = self
        collectionView.dataSource = self
        searchController.searchBar.delegate = self
    }
    

    

    
    
    
    
}

extension HomeViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = viewModel.getProduct(indexPath: indexPath)
        let detailViewModel = DetailViewModel(product: product)
        let detailViewControlelr = DetailViewController(viewModel: detailViewModel)
        self.navigationController?.pushViewController(detailViewControlelr, animated: true)
        
    }
}
extension HomeViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.countOfProducts
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: viewModel.getProduct(indexPath: indexPath))
        return cell
    }
    
    
    
    
    
    
}

extension HomeViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 32
        
        let minimumSpacing: CGFloat = 10
        let availableWidth = view.frame.width - padding - minimumSpacing
        let itemWidth = availableWidth / 2
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
}



extension HomeViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterProductsWith(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchBarCancelButtonClicked()
    }
    
    
}

extension HomeViewController : HomeViewModelOutput {
    func collectionViewReloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}




#Preview(""){
    
    UINavigationController(rootViewController: HomeViewController(viewModel: HomeViewModel(productService: ProductService(networkManager: AFNetworkManager()))))
    
}


