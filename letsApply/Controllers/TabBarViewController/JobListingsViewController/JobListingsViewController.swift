//
//  JobListingsViewController.swift.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/14.
//

import Foundation
import UIKit
import FirebaseAuth

class JobListingsViewController: UIViewController, UISearchBarDelegate {
    private let viewModel = JobListingsViewModel()
    
    private var hasReachedEnd = false
    
    private let loadingSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search Jobs"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        return searchController
    }()
    
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.register(JobCollectionViewCell.self, forCellWithReuseIdentifier: JobCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
//    private lazy var loadingSpinner: UIActivityIndicatorView = {
//        let spinner = UIActivityIndicatorView(style: .large)
//        spinner.translatesAutoresizingMaskIntoConstraints = false
//        return spinner
//    }()
    
//    lazy var filtersStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .horizontal
//        stackView.distribution = .fillEqually
//        stackView.spacing = 10
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        return stackView
//    }()
    
//    lazy var collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//
//        layout.itemSize = CGSize(width: view.frame.width - 32, height: 220)
//        layout.minimumLineSpacing = 16
//        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
//        
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//
//        collectionView.backgroundColor = .systemGroupedBackground
//        collectionView.register(JobCollectionViewCell.self, forCellWithReuseIdentifier: JobCollectionViewCell.reuseIdentifier)
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        return collectionView
//    }()
//    
//    lazy var signUpButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Sign Up", for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.backgroundColor = UIColor.systemPink
//        button.layer.cornerRadius = 12
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
//        button.isHidden = true
//        return button
//    }()
    
//    lazy var loadingSpinner: UIActivityIndicatorView = {
//        let spinner = UIActivityIndicatorView(style: .large)
//        spinner.translatesAutoresizingMaskIntoConstraints = false
//        return spinner
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        setupNavigationBar()
        setupUI()
        fetchJobs()
    }

    private func setupNavigationBar() {
        title = "Home"
        
        // Configure UISearchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Jobs"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // Add Filter button
        let filterImage = UIImage(systemName: "line.horizontal.3.decrease.circle")
        let filterButton = UIBarButtonItem(image: filterImage, style: .plain, target: self, action: #selector(handleFilter))
        navigationItem.leftBarButtonItem = filterButton
        
        // Add Sign-Up button
        let signUpButton = UIBarButtonItem(title: "Sign Up", style: .done, target: self, action: #selector(handleSignUp))
        signUpButton.tintColor = .systemPink
        navigationItem.rightBarButtonItem = signUpButton
    }
    
    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(loadingSpinner)
        
        loadingSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//
//        let filterTitles = ["City", "Experience", "Company"]
//        for title in filterTitles {
//            let button = UIButton(type: .system)
//            button.setTitle(title, for: .normal)
//            button.setTitleColor(.systemPurple, for: .normal)
//            button.backgroundColor = .systemGray5
//            button.layer.cornerRadius = 8
//            button.layer.masksToBounds = true
//            button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
//            filtersStackView.addArrangedSubview(button)
        }
        

        
//        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
//        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
//        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
//        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
//        filtersStackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16).isActive = true
//        filtersStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
//        filtersStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
//        filtersStackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
//
//        
//        
//        signUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
//        signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        signUpButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
//    }
    
    private func fetchJobs() {
        loadingSpinner.startAnimating()
        viewModel.authenticateAndFetchJobs { [weak self] in
            DispatchQueue.main.async {
                self?.loadingSpinner.stopAnimating()
                self?.collectionView.reloadData()
            }
        }
    }
    
    @objc private func handleSignUp() {
        let signUpVC = SignUpViewController()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @objc private func handleFilter() {
        let filterVC = FilterViewController()
        filterVC.delegate = self
        let navController = UINavigationController(rootViewController: filterVC)
        present(navController, animated: true, completion: nil)
    }
}

extension JobListingsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredJobs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JobCollectionViewCell.reuseIdentifier, for: indexPath) as? JobCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: viewModel.filteredJobs[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let job = viewModel.filteredJobs[indexPath.row]
        let detailsVC = JobDetailsViewController(job: job)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    // Dynamic item size based on screen width
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt
        indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 32 // 16 left + 16 right
        let availableWidth = collectionView.frame.width - padding
        let width = availableWidth
        let height: CGFloat = 220 // Fixed height as per original layout
        return CGSize(width: width, height: height)
    }
}

extension JobListingsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {

        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(performSearch), object: nil)
        perform(#selector(performSearch), with: nil, afterDelay: 0.3)
    }
    
    @objc private func performSearch() {
        guard let query = searchController.searchBar.text, !query.isEmpty else {
            viewModel.resetFilters()
            collectionView.reloadData()
            return
        }
        viewModel.filterJobs(with: query)
        collectionView.reloadData()
    }
}
extension JobListingsViewController: FilterViewControllerDelegate {
    func didApplyFilters(_ filters: JobFilters) {
        viewModel.applyFilters(filters)
        collectionView.reloadData()
    }
}
