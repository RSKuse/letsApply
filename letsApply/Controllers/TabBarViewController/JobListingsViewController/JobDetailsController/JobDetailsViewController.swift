//
//  JobDetailsViewController.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/25.
//

import UIKit
import FirebaseAuth

class JobDetailsViewController: UIViewController {
    
    let job: Job
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    let firebaseAuthService = FirebaseAuthenticationService.shared
    
    lazy var jobsDetailTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    init(job: Job) {
        self.job = job
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerCells()
    }
    
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Job Details"
        view.addSubview(jobsDetailTableView)
        
        jobsDetailTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        jobsDetailTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        jobsDetailTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        jobsDetailTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
    
    func registerCells() {
        jobsDetailTableView.register(JobHeaderTableViewCell.self, forCellReuseIdentifier: JobHeaderTableViewCell.reuseIdentifier)
        jobsDetailTableView.register(JobInfoTableViewCell.self, forCellReuseIdentifier: JobInfoTableViewCell.reuseIdentifier)
        jobsDetailTableView.register(JobDetailTableViewCell.self, forCellReuseIdentifier: JobDetailTableViewCell.reuseIdentifier)
        jobsDetailTableView.register(ApplyButtonTableViewCell.self, forCellReuseIdentifier: ApplyButtonTableViewCell.reuseIdentifier)
    }
    
    @objc func applyForJob() {
        // Check user authentication status
        if firebaseAuthService.isAuthenticatedAnonymously {
            // Show sign-up prompt for anonymous users
            let alert = UIAlertController(
                title: "Sign Up to Apply",
                message: "Sign up now to unlock the convenience of applying for jobs directly through the app. Take your first step toward landing your dream job!",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Sign Up", style: .default, handler: { _ in
                self.handleSignUp()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            // Allow job application
            let alert = UIAlertController(
                title: "Application Sent",
                message: "You have successfully applied for \(job.title).",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func handleSignUp() {
        let signUpVC = SignUpViewController()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
}
