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
        collectionView.register(JobCategoryCell.self, forCellWithReuseIdentifier: JobCategoryCell.identifier) // Correct cell registration
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
        collectionView.register(JobCell.self, forCellWithReuseIdentifier: JobCell.identifier) // Correct cell registration
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
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(profileImageView)
        view.addSubview(greetingLabel)
        view.addSubview(notificationButton)
        view.addSubview(categoriesCollectionView)
        view.addSubview(jobsCollectionView)
        
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        
        jobsCollectionView.dataSource = self
        jobsCollectionView.delegate = self
        
        // Auto Layout Constraints
        
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        greetingLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        greetingLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 15).isActive = true
        
        notificationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        notificationButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        notificationButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        notificationButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        categoriesCollectionView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20).isActive = true
        categoriesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        categoriesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        categoriesCollectionView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        jobsCollectionView.topAnchor.constraint(equalTo: categoriesCollectionView.bottomAnchor, constant: 20).isActive = true
        jobsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        jobsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        jobsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
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
            self?.homeViewModel.fetchRelevantJobs(for: profile) { jobs in
                self?.jobs = jobs
                self?.jobsCollectionView.reloadData()
            }
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension HomeScreenViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoriesCollectionView {
            return homeViewModel.categories.count
        } else {
            return jobs.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoriesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JobCategoryCell.identifier, for: indexPath) as! JobCategoryCell
            let category = homeViewModel.categories[indexPath.row]
            cell.configure(with: category)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JobCell.identifier, for: indexPath) as! JobCell
            let job = jobs[indexPath.row]
            cell.configure(with: job)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoriesCollectionView {
            return CGSize(width: 100, height: 100)
        } else {
            return CGSize(width: collectionView.frame.width, height: 120)
        }
    }
}
