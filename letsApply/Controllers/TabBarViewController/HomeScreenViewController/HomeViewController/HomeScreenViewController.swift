//
//  HomeScreenViewController.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/12/16.
//

import Foundation
import UIKit
import FirebaseAuth

class HomeScreenViewController: UIViewController {
    
    let viewModel = HomeViewModel()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var greetingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .darkGray
        label.text = "Hello, User"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
   lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search jobs..."
        return searchController
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        fetchUserProfile()
        
        // Listen for profile updates
        NotificationCenter.default.addObserver(self, selector: #selector(fetchUserProfile), name: .profileUpdated, object: nil)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bell"),
                                                            style: .plain,
                                                            target: self,
                                                            action: nil)
        
        view.addSubview(profileImageView)
        view.addSubview(greetingLabel)
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(JobCell.self, forCellWithReuseIdentifier: JobCell.identifier)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            profileImageView.widthAnchor.constraint(equalToConstant: 60),
            profileImageView.heightAnchor.constraint(equalToConstant: 60),
            
            greetingLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            greetingLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            
            collectionView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
    }
    
    @objc private func fetchUserProfile() {
        if let uid = FirebaseAuth.Auth.auth().currentUser?.uid {
            viewModel.fetchUserProfile(uid: uid)
        }
    }
    
    private func updateUI() {
        if let profile = viewModel.userProfile {
            greetingLabel.text = "Hello, \(profile.name)"
            if let profileUrl = profile.profilePictureUrl {
                ProfilePictureService.shared.fetchProfilePicture(urlString: profileUrl) { [weak self] image in
                    self?.profileImageView.image = image
                }
            }
        }
        collectionView.reloadData()
    }
}

extension HomeScreenViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.tailoredJobs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JobCell.identifier, for: indexPath) as? JobCell else {
            return UICollectionViewCell()
        }
        let job = viewModel.tailoredJobs[indexPath.item]
        cell.configure(with: job)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 20, height: 120)
    }
}
