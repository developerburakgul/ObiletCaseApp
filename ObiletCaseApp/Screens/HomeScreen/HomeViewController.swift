//
//  ViewController.swift
//  ObiletCaseApp
//
//  Created by Burak Gül on 12.08.2024.
//

import UIKit
import SnapKit


//MARK: - HomeViewControllerInterface
protocol HomeViewControllerInterface: AnyObject {
    func reloadData()
    func setup()
    func setupNavigationBar()
    func showNoConnection()
    func hideNoConnection()
    func beginRefreshing()
    func endRefreshing()
}


final class HomeViewController: UIViewController {
    private var viewModel : HomeViewModelInterface
    
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
    private var noConnectionImageView : UIImageView = {
       let noConnectionImageView = UIImageView()
        noConnectionImageView.image = UIImage(systemName: "wifi.slash")
        noConnectionImageView.isHidden = true
        noConnectionImageView.tintColor = .systemRed
        return noConnectionImageView
    }()
    private var refreshControl : UIRefreshControl = {
        let refreshControl : UIRefreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    //MARK: - Init Functions
    init(viewModel : HomeViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.view = self
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    //MARK: - Setup Functions
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupNoConnectionImageView(){
        let minSize = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
        view.addSubview(noConnectionImageView)
        noConnectionImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(minSize * 0.5)
            make.height.equalTo(noConnectionImageView.snp.width)
        }
    }
    private func setupDelegates()  {
        collectionView.delegate = self
        collectionView.dataSource = self
        searchController.searchBar.delegate = self
    }
    
    func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(pulledDownRefreshControl), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        refreshControl.tintColor = .red
    }
    
    @objc private func pulledDownRefreshControl(){
        viewModel.pulledDownRefreshControl()
    }
}

//MARK: - UICollectionViewDelegate
extension HomeViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = viewModel.getProduct(indexPath: indexPath)
        let detailViewModel = DetailViewModel(product: product)
        let detailViewControlelr = DetailViewController(viewModel: detailViewModel)
        self.navigationItem.backButtonDisplayMode = .generic
        self.navigationController?.pushViewController(detailViewControlelr, animated: true)
    }
}
//MARK: - UICollectionViewDataSource
extension HomeViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.countOfProduct
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: viewModel.getProduct(indexPath: indexPath))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionHeaderView.identifier, for: indexPath) as? CollectionHeaderView else {
            return UICollectionReusableView()
        }
        header.delegate = self
        
        
        return header
    }

}

//MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 32
        let minimumSpacing: CGFloat = 10
        let availableWidth = view.frame.width - padding - minimumSpacing
        let itemWidth = availableWidth / 2
        return CGSize(width: itemWidth, height: itemWidth)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }

}


//MARK: - UISearchBarDelegate
extension HomeViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.textDidChangeWith(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchBarCancelButtonClicked()
    }
}

//MARK: - HomeViewControllerInterface Implementation
extension HomeViewController : HomeViewControllerInterface {
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    func setup()  {
        setupNavigationBar()
        setupCollectionView()
        setupDelegates()
        setupNoConnectionImageView()
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        collectionView.register(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeaderView.identifier)

        view.backgroundColor = .systemBackground
        setupRefreshControl()
    }
    func setupNavigationBar(){
        self.navigationItem.title = "Home Screen"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.searchController = searchController
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.label]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
    }
    
    func showNoConnection() {
        noConnectionImageView.isHidden = false
    }
    
    func hideNoConnection() {
        noConnectionImageView.isHidden = true
        
    }
    
    func beginRefreshing() {
        collectionView.refreshControl?.beginRefreshing()
    }
    
    func endRefreshing() {
        collectionView.refreshControl?.endRefreshing()
    }
    

}


extension HomeViewController : CategorySelectionDelegate {
    func didUnSelectCategory(_ category: Category?) {
        viewModel.didUnSelectCategory(category)
    }
    
    func didSelectCategory(_ category: Category?) {
        viewModel.didSelectCategory(category)
    }
}

#Preview(""){
    
    UINavigationController(rootViewController: HomeViewController(viewModel: HomeViewModel(productService: ProductService(networkManager: AFNetworkManager()))))
    
}


