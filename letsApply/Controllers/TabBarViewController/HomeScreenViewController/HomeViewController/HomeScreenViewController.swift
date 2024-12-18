//
//  HomeScreenViewController.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/12/16.
//
import Foundation
import UIKit

class HomeScreenViewController: UIViewController {
    
    private let homeViewModel = HomeViewModel()
    private var jobs: [Job] = []
    
    // MARK: - UI Elements
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var greetingLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello!"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController()
        controller.searchBar.placeholder = "Search jobs..."
        return controller
    }()
    
    private lazy var notificationButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "bell.fill")
        button.setImage(image, for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(JobCategoryCell.self, forCellWithReuseIdentifier: JobCategoryCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var jobsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width - 40, height: 120)
        layout.minimumLineSpacing = 15
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(JobCell.self, forCellWithReuseIdentifier: JobCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    

    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        loadUserProfile()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(profileImageView)
        view.addSubview(greetingLabel)
        view.addSubview(notificationButton)
        view.addSubview(categoriesCollectionView)
        
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        
        // Auto Layout Constraints
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            profileImageView.widthAnchor.constraint(equalToConstant: 60),
            profileImageView.heightAnchor.constraint(equalToConstant: 60),
            
            greetingLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            greetingLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 15),
            
            notificationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            notificationButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            notificationButton.widthAnchor.constraint(equalToConstant: 30),
            notificationButton.heightAnchor.constraint(equalToConstant: 30),
            
            categoriesCollectionView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            categoriesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoriesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoriesCollectionView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // MARK: - Load Data
    
    private func loadUserProfile() {
        homeViewModel.fetchUserProfile { [weak self] profile in
            self?.greetingLabel.text = "Hello, \(profile.name)!"
            self?.homeViewModel.loadProfileImage(urlString: profile.profilePictureUrl) { image in
                self?.profileImageView.image = image
            }
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension HomeScreenViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JobCategoryCell.identifier, for: indexPath) as! JobCategoryCell
        let category = homeViewModel.categories[indexPath.row]
        cell.configure(with: category)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
