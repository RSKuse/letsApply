//
//  JobDetailsViewController.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/25.
//

import Foundation
import UIKit

class JobDetailsViewController: UIViewController {

    private let job: Job
    
    init(job: Job) {
        self.job = job
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Apply Button using ButtonFacade
    lazy var applyButton: UIButton = {
        return ButtonFacade.shared.createButton(
            title: "Apply Now",
            backgroundColor: .systemBlue,
            target: self,
            action: #selector(applyForJob)
        )
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var companyNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Job Details"
        setupUI()
        displayJobDetails()
    }

    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(companyNameLabel)
        view.addSubview(locationLabel)
        view.addSubview(descriptionTextView)
        view.addSubview(applyButton)

        // Layout Constraints
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        companyNameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        companyNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        locationLabel.topAnchor.constraint(equalTo: companyNameLabel.bottomAnchor, constant: 10).isActive = true
        locationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        descriptionTextView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 20).isActive = true
        descriptionTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        descriptionTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        descriptionTextView.heightAnchor.constraint(equalToConstant: 200).isActive = true

        applyButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 20).isActive = true
        applyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        applyButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        applyButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    @objc private func applyForJob() {
        let alert = UIAlertController(
            title: "Application Sent",
            message: "You have successfully applied for \(job.title).",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func displayJobDetails() {
        titleLabel.text = job.title
        companyNameLabel.text = job.companyName
        locationLabel.text = "Location: \(job.location)"
        descriptionTextView.text = job.description
    }
}
