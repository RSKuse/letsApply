//
//  JobDetailsViewController.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/25.
//

import Foundation
import UIKit

class JobDetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    let job: Job
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    // MARK: - UI Elements
    
    lazy var floatingSignUpButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "person.crop.circle.badge.plus")
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 28
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initializer
    
    init(job: Job) {
        self.job = job
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerCells()
        configureHeaderView()
        setupFloatingSignUpButton()
    }
    
    // MARK: - Setup Methods
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Job Details"
        
        // TableView
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func registerCells() {
        tableView.register(JobHeaderTableViewCell.self, forCellReuseIdentifier: JobHeaderTableViewCell.identifier)
        tableView.register(JobInfoTableViewCell.self, forCellReuseIdentifier: JobInfoTableViewCell.identifier)
        tableView.register(JobDetailTableViewCell.self, forCellReuseIdentifier: JobDetailTableViewCell.identifier)
        tableView.register(ApplyButtonTableViewCell.self, forCellReuseIdentifier: ApplyButtonTableViewCell.identifier)
    }
    
    func configureHeaderView() {
        // If you have a custom header view, configure it here.
    }
    
    func setupFloatingSignUpButton() {
        view.addSubview(floatingSignUpButton)
        
        NSLayoutConstraint.activate([
            floatingSignUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            floatingSignUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            floatingSignUpButton.widthAnchor.constraint(equalToConstant: 56),
            floatingSignUpButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    // MARK: - Actions
    
    @objc func handleSignUp() {
        let signUpVC = SignUpViewController()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @objc func applyForJob() {
        let alert = UIAlertController(
            title: "Application Sent",
            message: "You have successfully applied for \(job.title).",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
