//
//  ProductCollectionViewCell.swift
//  ObiletCaseApp
//
//  Created by Burak Gül on 12.08.2024.
//

import Foundation
import UIKit
import Kingfisher


final class ProductCollectionViewCell: UICollectionViewCell {
    //MARK: - Identifier
    static let identifier = "ProductCollectionViewCell"
    
    //MARK: - UI Components
    
    private var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private var visualEffectView : UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemThinMaterial)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        
        visualEffectView.alpha = 0.8
        return visualEffectView
        
        
        
    }()
    
    private var stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private var titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.textAlignment = .left
        label.font  = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    private var descriptionLabel : UILabel = {
        
        let label = UILabel()
        label.text = "Description"
        label.textAlignment = .left
        label.font  = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    //MARK: - Init Functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setups
    private func setup() {
        setupImageView()
        setupVisualEffectView()
        setupStackView()
        setupLabels()
        setupCornerRadius()
    }
    
    private func setupImageView() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.75)
        }
    }
    private func setupVisualEffectView() {
        contentView.addSubview(visualEffectView)
        visualEffectView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.25)
        }
    }
    private func setupStackView() {
        visualEffectView.contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
    }
    private func setupLabels() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        
    }
    
    private func setupCornerRadius() {
        contentView.layer.cornerRadius = 10
            contentView.layer.masksToBounds = true
    }
    
    //MARK: - Public Functions
    
    func configure(with product : Product)  {
        self.titleLabel.text = product.title
        self.descriptionLabel.text = product.description
        
        
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: URL(string: product.image),
            placeholder: nil,
            options: [
                .transition(.fade(0.2)),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ])
        
    }
    
}


//#Preview(""){
//    ProductCollectionViewCell()
//}

#Preview(""){
    HomeViewController(viewModel: HomeViewModel(productService: ProductService(networkManager: AFNetworkManager())))
}
