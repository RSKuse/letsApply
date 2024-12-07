//
//  HomeScreenViewController.swift.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/14.
//

import Foundation
import UIKit
import FirebaseAuth

class HomeScreenViewController: UIViewController, UISearchBarDelegate {
    private let viewModel = HomeViewModel()

    // MARK: - UI Components
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Jobs"
        searchBar.searchBarStyle = .minimal
        searchBar.layer.cornerRadius = 10
        searchBar.layer.masksToBounds = true
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor(named: "#AB016C")?.cgColor
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    lazy var filtersStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width - 32, height: 180) // Adjusted for larger cards
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16) // Padding around the section
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(JobCollectionViewCell.self, forCellWithReuseIdentifier: JobCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "#AB016C")
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "#FAE1F0")
        setupUI()
        fetchJobs()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.addSubview(searchBar)
        view.addSubview(filtersStackView)
        view.addSubview(collectionView)
        view.addSubview(signUpButton)
        
        // Add Filter Buttons
        let filterTitles = ["City", "Experience", "Company"]
        for title in filterTitles {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor(named: "#AB016C")
            button.layer.cornerRadius = 8
            button.layer.masksToBounds = true
            filtersStackView.addArrangedSubview(button)
        }
        
        // Add Constraints
        NSLayoutConstraint.activate([
            // Search Bar
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            
            // Filters Stack View
            filtersStackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            filtersStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filtersStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filtersStackView.heightAnchor.constraint(equalToConstant: 40),
            
            // Collection View
            collectionView.topAnchor.constraint(equalTo: filtersStackView.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -16),
            
            // Sign-Up Button
            signUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.widthAnchor.constraint(equalToConstant: 200),
            signUpButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Fetch Jobs
    private func fetchJobs() {
        viewModel.fetchJobs { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Actions
    @objc private func handleSignUp() {
        let signUpVC = SignUpViewController()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
}

// MARK: - UICollectionView Data Source & Delegate
extension HomeScreenViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.jobs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JobCollectionViewCell.reuseIdentifier, for: indexPath) as? JobCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: viewModel.jobs[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let job = viewModel.jobs[indexPath.row]
        let detailsVC = JobDetailsViewController(job: job)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
