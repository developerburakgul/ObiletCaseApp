//
//  File.swift
//  ObiletCaseApp
//
//  Created by Burak Gül on 16.08.2024.
//

import Foundation
import UIKit

protocol CategorySelectionDelegate : AnyObject {
    func didSelectCategory(_ category: Category?)
}

final class CollectionHeaderView: UICollectionReusableView {
    static let identifier = "CollectionHeaderView"
    
    weak var delegate : CategorySelectionDelegate?
    private var categoryButtons: [UIButton] = []
    private var selectedButton: UIButton?
    private lazy var stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        return stackView
    }()
    
    
    //MARK: - Init Functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
        setupButtons()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    private func setupStackView() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
    }
    
    private func setupButtons() {
        Category.allCases.forEach { category in
            let button = UIButton.createCategoryButton(withTitle: category.rawValue)
            button.heightAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
            button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
            categoryButtons.append(button)
            stackView.addArrangedSubview(button)
        }
    }
    
    @objc private func categoryButtonTapped(_ sender: UIButton) {
        if let selectedButton = selectedButton, selectedButton == sender {
            deselectButton(selectedButton)
        } else {
            deselectButton(selectedButton)
            selectButton(sender)
        }
    }
    
    private func selectButton(_ button: UIButton) {
        button.backgroundColor = UIColor(red: 0.0, green: 0.6, blue: 0.0, alpha: 1.0)
        selectedButton = button
        
        if let title = button.titleLabel?.text, let category = Category(rawValue: title) {
            delegate?.didSelectCategory(category)
        }
    }
    
    private func deselectButton(_ button: UIButton?) {
        button?.backgroundColor = .clear
        selectedButton = nil
        delegate?.didSelectCategory(nil)
    }

    
    
}

#Preview(""){
    
    UINavigationController(rootViewController: HomeViewController(viewModel: HomeViewModel(productService: ProductService(networkManager: AFNetworkManager()))))
    
}
