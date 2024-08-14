//
//  DetailViewModel.swift
//  ObiletCaseApp
//
//  Created by Burak Gül on 13.08.2024.
//

import Foundation


protocol DetailViewModelOutput : AnyObject{
    func updateViewWith(_ product : Product)
}

class DetailViewModel {
    private var product : Product
    weak var output : DetailViewModelOutput?
    
    
    init(product: Product) {
        self.product = product
    }
    
    func updateView() {
        output?.updateViewWith(product)
    }
}
