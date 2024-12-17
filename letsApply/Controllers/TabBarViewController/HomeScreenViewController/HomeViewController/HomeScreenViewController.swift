//
//  HomeScreenViewController.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/12/16.
//

import UIKit
import FirebaseAuth

class HomeScreenViewController: UIViewController {
    
    let viewModel = HomeViewModel()
    private var searchController: UISearchController!
    
    // MARK: - UI Elements
    
    lazy var topContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemPink.cgColor, UIColor.systemPurple.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200)
        view.layer.insertSublayer(gradient, at: 0)
        return view
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var greetingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .white
        label.text = "Hey, User 👋"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var notificationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bell.fill"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var searchBarContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for jobs..."
        searchBar.barTintColor = .clear
        searchBar.backgroundImage = UIImage()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    lazy var metricsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 100)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MetricCardCell.self, forCellWithReuseIdentifier: MetricCardCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        fetchUserProfile()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Add subviews
        view.addSubview(topContainerView)
        topContainerView.addSubview(profileImageView)
        topContainerView.addSubview(greetingLabel)
        topContainerView.addSubview(notificationButton)
        view.addSubview(searchBarContainerView)
        searchBarContainerView.addSubview(searchBar)
        view.addSubview(metricsCollectionView)
        
        // Add Constraints
        setupConstraints()
        
        // CollectionView Delegate
        metricsCollectionView.delegate = self
        metricsCollectionView.dataSource = self
    }
    
    private func setupConstraints() {
        // Top Container
        NSLayoutConstraint.activate([
            topContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            topContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topContainerView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        // Profile Image
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: topContainerView.topAnchor, constant: 60),
            profileImageView.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: 20),
            profileImageView.widthAnchor.constraint(equalToConstant: 60),
            profileImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        // Greeting Label
        NSLayoutConstraint.activate([
            greetingLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            greetingLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10)
        ])
        
        // Notification Button
        NSLayoutConstraint.activate([
            notificationButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            notificationButton.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor, constant: -20)
        ])
        
        // Search Bar Container
        NSLayoutConstraint.activate([
            searchBarContainerView.topAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: -20),
            searchBarContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBarContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBarContainerView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: searchBarContainerView.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: searchBarContainerView.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: searchBarContainerView.trailingAnchor),
            searchBar.bottomAnchor.constraint(equalTo: searchBarContainerView.bottomAnchor)
        ])
        
        // Metrics CollectionView
        NSLayoutConstraint.activate([
            metricsCollectionView.topAnchor.constraint(equalTo: searchBarContainerView.bottomAnchor, constant: 10),
            metricsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            metricsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            metricsCollectionView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func setupViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
    }
    
    private func fetchUserProfile() {
        if let uid = Auth.auth().currentUser?.uid {
            viewModel.fetchUserProfile(uid: uid)
        }
    }
    
    private func updateUI() {
        if let profile = viewModel.userProfile {
            greetingLabel.text = "Hey, \(profile.name) 👋"
            
            if let profileUrl = profile.profilePictureUrl {
                ProfilePictureService.shared.fetchProfilePicture(urlString: profileUrl) { [weak self] image in
                    self?.profileImageView.image = image
                }
            } else {
                profileImageView.image = UIImage(systemName: "person.circle.fill")
            }
        }
        metricsCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension HomeScreenViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3 // Number of metrics
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MetricCardCell.reuseIdentifier, for: indexPath) as? MetricCardCell else {
            return UICollectionViewCell()
        }
        
        let titles = ["Live Jobs", "Companies", "New Jobs"]
        let values = ["44.5K", "3K", "64.5K"]
        cell.configure(title: titles[indexPath.row], value: values[indexPath.row])
        return cell
    }
}
