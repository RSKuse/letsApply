//
//  JobListingsViewController.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/25.
//

import Foundation
import UIKit

class JobListingsViewController: UIViewController {
    
    private let viewModel = JobListingsViewModel()
    
    // UI Elements
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(JobTableViewCell.self, forCellReuseIdentifier: JobTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Filters", for: .normal)
        button.addTarget(self, action: #selector(openFilters), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Job Listings"
        setupUI()
        fetchJobListings()
    }
    
    func setupUI() {
        view.addSubview(filterButton)
        view.addSubview(tableView)
        
        // Constraints
        filterButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        filterButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        tableView.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: 10).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func fetchJobListings() {
        viewModel.fetchJobs { [weak self] in
            DispatchQueue.main.async {
                print("Jobs fetched for display: \(self?.viewModel.jobs)")
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc private func openFilters() {
        let filtersVC = JobFiltersViewController()
        filtersVC.delegate = self
        navigationController?.pushViewController(filtersVC, animated: true)
    }
}

extension JobListingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.jobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: JobTableViewCell.identifier, for: indexPath) as? JobTableViewCell else {
            return UITableViewCell()
        }
        let job = viewModel.jobs[indexPath.row]
        cell.configure(with: job)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let job = viewModel.jobs[indexPath.row]
        let jobDetailsVC = JobDetailsViewController(job: job)
        navigationController?.pushViewController(jobDetailsVC, animated: true)
    }
}

extension JobListingsViewController: JobFiltersDelegate {
    func applyFilters(_ filters: JobFilters) {
        viewModel.applyFilters(filters: filters) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
