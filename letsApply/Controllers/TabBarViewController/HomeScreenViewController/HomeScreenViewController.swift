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
    
    private var hasReachedEnd = false
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Jobs"
        searchBar.searchBarStyle = .minimal
        searchBar.layer.cornerRadius = 10
        searchBar.layer.masksToBounds = true
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.systemGray4.cgColor
        searchBar.backgroundColor = .systemGray6
        searchBar.barTintColor = .systemGray6
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

        layout.itemSize = CGSize(width: view.frame.width - 32, height: 220)
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
    
    lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemPink
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    lazy var loadingSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        setupUI()
        fetchJobs()
    }
    
    private func setupUI() {
        view.addSubview(searchBar)
        view.addSubview(filtersStackView)
        view.addSubview(collectionView)
        view.addSubview(signUpButton)
        view.addSubview(loadingSpinner)
        
        let filterTitles = ["City", "Experience", "Company"]
        for title in filterTitles {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setTitleColor(.systemPurple, for: .normal)
            button.backgroundColor = .systemGray5
            button.layer.cornerRadius = 8
            button.layer.masksToBounds = true
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            filtersStackView.addArrangedSubview(button)
        }
        
        loadingSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        filtersStackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16).isActive = true
        filtersStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        filtersStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        filtersStackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        collectionView.topAnchor.constraint(equalTo: filtersStackView.bottomAnchor, constant: 16).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -16).isActive = true
        
        signUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signUpButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    private func fetchJobs() {
        loadingSpinner.startAnimating()
        viewModel.fetchJobs { [weak self] in
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
}

// MARK: - UICollectionView DataSource & Delegate
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

extension HomeScreenViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - frameHeight - 50 {
            signUpButton.isHidden = false
        } else {
            signUpButton.isHidden = true
        }
    }
}
