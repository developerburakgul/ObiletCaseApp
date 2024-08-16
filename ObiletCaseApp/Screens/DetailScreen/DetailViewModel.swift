//
//  DetailViewModel.swift
//  ObiletCaseApp
//
//  Created by Burak Gül on 13.08.2024.
//

import Foundation

//MARK: - DetailViewModelInterface
protocol DetailViewModelInterface {
    func viewDidLoad()
    func viewWillAppear()
    func updateView()
}


final class DetailViewModel {
    private var product : Product
    weak var view : DetailViewControllerInterface?
    init(product: Product) {
        self.product = product
    }
}

//MARK: -  DetailViewModelInterface Implementation
extension DetailViewModel : DetailViewModelInterface {
    func viewDidLoad() {
        view?.setup()
        updateView()
    }
    
    func viewWillAppear() {
        view?.setupNavigationBar()
    }
    
    func updateView() {
        view?.updateViewWith(product)
    }
    
    
}
