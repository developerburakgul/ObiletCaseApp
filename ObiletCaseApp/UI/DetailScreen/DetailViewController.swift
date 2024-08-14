//
//  DetailViewController.swift
//  ObiletCaseApp
//
//  Created by Burak Gül on 13.08.2024.
//

import UIKit

class DetailViewController: UIViewController {

    private let viewModel : DetailViewModel
    
    //MARK: - UI Components
    private let scrollView : UIScrollView = {
        let scrollView : UIScrollView = UIScrollView()
//        scrollView.backgroundColor = .cyan
        scrollView.backgroundColor = .systemBackground
        return scrollView
    }()
    private let contentView : UIView = {
        let contentView : UIView = UIView()
//        contentView.backgroundColor = .yellow
        contentView.backgroundColor = .systemBackground
        return contentView
    }()
    private var imageView : UIImageView = {
       let imageview = UIImageView()
        imageview.image = UIImage(systemName: "star")
//        imageview.backgroundColor = .red
        imageview.backgroundColor = .systemBackground
        imageview.contentMode = .scaleAspectFit
        return imageview
    }()
    private var titleLabel : UILabel = {
       let titleLabel = UILabel()
        titleLabel.text = "Title"
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
//        titleLabel.backgroundColor = .green
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    private var descriptionLabel : UILabel = {
       let descriptionLabel = UILabel()
        descriptionLabel.text = "Description"
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .title3)
//        descriptionLabel.backgroundColor = .systemPink
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()
    private let starImageView : UIImageView = {
        let starImageView = UIImageView(image: UIImage(systemName: "star.fill"))
        starImageView.contentMode = .scaleAspectFit
//        starImageView.backgroundColor = .lightGray
        starImageView.tintColor = .systemYellow
        return starImageView
    }()
    private let rateLabel : UILabel = {
       let rateLabel = UILabel()
        rateLabel.text = "4.7"
        rateLabel.font = UIFont.preferredFont(forTextStyle: .title3)
//        rateLabel.backgroundColor = .red
        return rateLabel
    }() 
    private let countImageView : UIImageView = {
        let countImageView = UIImageView(image: UIImage(systemName: "cart"))
        countImageView.contentMode = .scaleAspectFit
//        countImageView.backgroundColor = .systemPink
        return countImageView
    }()
    private let countLabel : UILabel = {
       let countLabel = UILabel()
        countLabel.text = "50"
        countLabel.font = UIFont.preferredFont(forTextStyle: .title3)
//        countLabel.backgroundColor = .gray
        return countLabel
    }()
    private let priceImageView : UIImageView = {
        let priceImageView = UIImageView(image: UIImage(systemName: "dollarsign.circle.fill"))
        priceImageView.contentMode = .scaleAspectFit
//        priceImageView.backgroundColor = .red
        priceImageView.tintColor = .systemGreen
        return priceImageView
    }()
    private let priceLabel : UILabel = {
       let priceLabel = UILabel()
        priceLabel.text = "50"
        priceLabel.font = UIFont.preferredFont(forTextStyle: .title3)
//        priceLabel.backgroundColor = .orange
        return priceLabel
    }()
 
    //MARK: - Init Functions
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.viewModel.output = self
        viewModel.updateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    //MARK: - Setup
    private func setup() {
        self.view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupScrollView()
        setupContentView()
        setupImageView()
        setupTitleLabel()
        setupDescriptionLabel()
        setupStarImageView()
        setupRateLabel()
        setupCountImageView()
        setupCountLabel()
        setupPriceImageView()
        setupPriceLabel()
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = "Detail Screen"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    } 
    private func setupContentView() {
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    } 
    private func setupImageView() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(view.snp.height).multipliedBy(0.5)
        }
    }
    private func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(imageView.snp.bottom).offset(16)
        }
    }
    
    private func setupDescriptionLabel() {
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
//            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    private func setupStarImageView() {
        contentView.addSubview(starImageView)
        starImageView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(view.snp.height).multipliedBy(0.04)
            make.width.equalTo(starImageView.snp.height)
            make.bottom.equalToSuperview().offset(-16)
        }
        
    } 
    private func setupRateLabel() {
        contentView.addSubview(rateLabel)
        rateLabel.snp.makeConstraints { make in
            make.leading.equalTo(starImageView.snp.trailing).offset(8)
            make.centerY.equalTo(starImageView.snp.centerY)
            make.height.equalTo(starImageView.snp.height)
            make.width.equalTo(starImageView.snp.width).multipliedBy(1.5)
        }
        
    } 
    private func setupCountImageView() {
        contentView.addSubview(countImageView)
        countImageView.snp.makeConstraints { make in
            make.leading.equalTo(rateLabel.snp.trailing).offset(16)
            make.centerY.equalTo(rateLabel.snp.centerY)
            make.height.equalTo(rateLabel.snp.height)
            make.width.equalTo(starImageView.snp.width)
        }
    }
    private func setupCountLabel() {
        contentView.addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.leading.equalTo(countImageView.snp.trailing).offset(8)
            make.centerY.equalTo(countImageView.snp.centerY)
            make.height.equalTo(countImageView.snp.height)
            make.width.equalTo(rateLabel.snp.width)
        }
    }
    private func setupPriceImageView() {
        contentView.addSubview(priceImageView)
        priceImageView.snp.makeConstraints { make in
            make.leading.equalTo(countLabel.snp.trailing).offset(16)
            make.centerY.equalTo(countLabel.snp.centerY)
            make.height.equalTo(countLabel.snp.height)
            make.width.equalTo(countImageView.snp.width)
        }
    }
    private func setupPriceLabel() {
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(priceImageView.snp.trailing).offset(8)
            make.centerY.equalTo(priceImageView.snp.centerY)
            make.height.equalTo(priceImageView.snp.height)
            make.width.equalTo(countLabel.snp.width).multipliedBy(2)
        }
    }

    

    
}

extension DetailViewController : DetailViewModelOutput {
    func updateViewWith(_ product: Product) {
        self.titleLabel.text = product.title
        self.descriptionLabel.text = product.description
        self.rateLabel.text =  "\(product.rating.rate)"
        self.countLabel.text =  "\(product.rating.count)"
        self.priceLabel.text = "\(product.price)"
        
        
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: URL(string: product.image),
            placeholder: nil,
            options: [
                .transition(.fade(0.2)),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ]) { result in
                switch result {
                case .success(let value):
                    return
                case .failure(let error):
                    print("Error setting image: \(error.localizedDescription)")
                }
            }
    }
    
    
    
    
}
#Preview(""){
    UINavigationController(rootViewController: DetailViewController(viewModel: DetailViewModel(product: Product(id: 2, title: "Burak is  ", price: 2500.00, description: "This is the description. It can be very long and will require scrolling to see the entire text.",category: "men", image: "https://avatars.githubusercontent.com/u/83167665?s=400&u=09405fb9f0a95b97b27778d163c19eb64bb3e95a&v=4", rating: Rating(rate: 4.7, count: 10)))))
}

