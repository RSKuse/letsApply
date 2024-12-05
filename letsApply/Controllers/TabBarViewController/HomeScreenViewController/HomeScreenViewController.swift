//
//  HomeScreenViewController.swift.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/14.
//

import Foundation
import UIKit
import FirebaseAuth

class HomeScreenViewController: UIViewController {

    private let viewModel = HomeViewModel()

    // MARK: - UI Components

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(JobTableViewCell.self, forCellReuseIdentifier: JobTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    lazy var signUpButton: UIButton = {
        return ButtonFacade.shared.createButton(
            title: "Sign Up",
            backgroundColor: .systemBlue,
            target: self,
            action: #selector(handleSignUp)
        )
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        fetchJobs()
    }

    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(signUpButton)

        // TableView Constraints
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -10).isActive = true

        // SignUp Button Constraints
        signUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signUpButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    private func fetchJobs() {
        viewModel.fetchJobs { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    @objc private func handleSignUp() {
        let signUpVC = SignUpViewController()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate
extension HomeScreenViewController: UITableViewDataSource, UITableViewDelegate {
    
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

     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return UITableView.automaticDimension
     }
}
