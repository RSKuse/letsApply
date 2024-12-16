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
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var greetingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        label.text = "Hey, User 👋"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var notificationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bell"), for: .normal)
        button.tintColor = .systemPink
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var metricsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MetricCell.self, forCellWithReuseIdentifier: MetricCell.reuseIdentifier)
        return collectionView
    }()
    
    lazy var filterButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.decrease.circle"),
                                    style: .plain, target: self, action: #selector(handleFilter))
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSearchController()
        setupViewModel()
        fetchUserProfile()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.titleView = greetingLabel
        navigationItem.rightBarButtonItem = filterButton
        
        // Add subviews
        view.addSubview(profileImageView)
        view.addSubview(notificationButton)
        view.addSubview(metricsCollectionView)
        
        // Constraints
        setupConstraints()
        
        // CollectionView Delegate
        metricsCollectionView.delegate = self
        metricsCollectionView.dataSource = self
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Profile Image
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            profileImageView.widthAnchor.constraint(equalToConstant: 60),
            profileImageView.heightAnchor.constraint(equalToConstant: 60),
            
            // Notification Button
            notificationButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            notificationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Metrics CollectionView
            metricsCollectionView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            metricsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            metricsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            metricsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search for jobs..."
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
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
    
    func updateUI() {
        if let profile = viewModel.userProfile {
            greetingLabel.text = "Hey, \(profile.name) 👋"
            
            if let profileUrl = profile.profilePictureUrl {
                // Use ProfilePictureService to fetch the image
                ProfilePictureService.shared.fetchProfilePicture(urlString: profileUrl) { [weak self] image in
                    guard let image = image else {
                        self?.profileImageView.image = UIImage(systemName: "person.circle") // Placeholder
                        return
                    }
                    self?.profileImageView.image = image
                }
            } else {
                // Set placeholder image when no URL is available
                profileImageView.image = UIImage(systemName: "person.circle")
            }
        }
        metricsCollectionView.reloadData()
    }

    // Helper method to fetch image asynchronously
    func fetchImageFromURL(urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }
    
    // MARK: - Actions
    
    @objc private func handleFilter() {
        print("Filter button tapped")
        // Implement filter functionality here
    }
}

// MARK: - UISearchBarDelegate
extension HomeScreenViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        print("Searching for \(query)")
        viewModel.searchJobs(query: query)
    }
}

// MARK: - UICollectionViewDelegate & DataSource
extension HomeScreenViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.tailoredJobs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MetricCell.reuseIdentifier, for: indexPath) as? MetricCell else {
            return UICollectionViewCell()
        }
        let job = viewModel.tailoredJobs[indexPath.row]
        cell.configure(with: job.title, value: job.companyName)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width / 2) - 20
        return CGSize(width: width, height: 100)
    }
}
