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
    
    private let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let jobTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let companyNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(white: 1.0, alpha: 0.9)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(white: 1.0, alpha: 0.85)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Display the salary range right in the header for clarity
    private let salaryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(white: 1.0, alpha: 0.85)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Info stack for Job Type & Location chips only
    private let infoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        // Use equal spacing to give them room to breathe
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private func createInfoChip(title: String, value: String) -> UIView {
        let container = UIView()
        container.layer.cornerRadius = 8
        container.backgroundColor = .white
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.1
        container.layer.shadowOffset = CGSize(width: 0, height: 2)
        container.layer.shadowRadius = 4
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        titleLabel.textColor = .systemGray
        titleLabel.text = title.uppercased()
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let valueLabel = UILabel()
        valueLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        valueLabel.textColor = .black
        valueLabel.text = value
        valueLabel.numberOfLines = 1
        valueLabel.textAlignment = .center
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(titleLabel)
        container.addSubview(valueLabel)
        
        // Constrain title and value within the chip
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            valueLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            valueLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            valueLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8)
        ])
        
        // Allow the chip to size itself naturally
        return container
    }
    
    private let segments: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Description", "Skills", "About Company"])
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Apply Now", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemPink
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(applyForJob), for: .touchUpInside)
        return button
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
        title = "Job Details"
        view.backgroundColor = .systemBackground
        setupUI()
        configureData()
        updateContent(for: 0)
    }
    
    private func setupUI() {
        view.addSubview(headerView)
        headerView.addSubview(jobTitleLabel)
        headerView.addSubview(companyNameLabel)
        headerView.addSubview(locationLabel)
        headerView.addSubview(salaryLabel)
        
        view.addSubview(infoStackView)
        view.addSubview(segments)
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        view.addSubview(applyButton)
        
        // Header constraints
        headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        // Make headerView height dynamic
        headerView.bottomAnchor.constraint(equalTo: salaryLabel.bottomAnchor, constant: 16).isActive = true
        
        jobTitleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20).isActive = true
        jobTitleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16).isActive = true
        jobTitleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16).isActive = true
        
        companyNameLabel.topAnchor.constraint(equalTo: jobTitleLabel.bottomAnchor, constant: 8).isActive = true
        companyNameLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16).isActive = true
        companyNameLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16).isActive = true
        
        locationLabel.topAnchor.constraint(equalTo: companyNameLabel.bottomAnchor, constant: 4).isActive = true
        locationLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16).isActive = true
        locationLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16).isActive = true
        
        salaryLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 4).isActive = true
        salaryLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16).isActive = true
        salaryLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16).isActive = true
        
        infoStackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16).isActive = true
        infoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        infoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        // Remove fixed height
        // infoStackView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        segments.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 16).isActive = true
        segments.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        segments.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        scrollView.topAnchor.constraint(equalTo: segments.bottomAnchor, constant: 16).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: applyButton.topAnchor, constant: -16).isActive = true
        
        contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16).isActive = true
        contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16).isActive = true
        contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32).isActive = true
        
        applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        applyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        applyButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        applyButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        segments.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyGradientToHeader()
    }
    
    private func applyGradientToHeader() {
        // Remove existing gradient layers to prevent duplication
        if let sublayers = headerView.layer.sublayers {
            for layer in sublayers {
                if layer is CAGradientLayer {
                    layer.removeFromSuperlayer()
                }
            }
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.systemPink.cgColor,
            UIColor.systemPurple.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = headerView.bounds
        headerView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func configureData() {
        jobTitleLabel.text = job.title
        companyNameLabel.text = job.companyName

        let locationParts = [job.location.city, job.location.region, job.location.country]
            .filter { !$0.isEmpty }
        locationLabel.text = locationParts.joined(separator: ", ")

        let salaryRange = "\(job.compensation.salaryRange.currency) \(job.compensation.salaryRange.min)-\(job.compensation.salaryRange.max)"
        salaryLabel.text = "Salary: \(salaryRange)"

        let jobTypeChip = createInfoChip(title: "Job Type", value: job.jobType)
        let locationChip = createInfoChip(title: "Location", value: job.location.city)

        infoStackView.addArrangedSubview(jobTypeChip)
        infoStackView.addArrangedSubview(locationChip)
    }
    
    @objc private func segmentChanged() {
        updateContent(for: segments.selectedSegmentIndex)
    }
    
    private func updateContent(for index: Int) {
        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        switch index {
        case 0:
            addSectionHeader("Job Description")
            addBodyText(job.description)
            
            addSectionHeader("Qualifications")
            if job.qualifications.isEmpty {
                addBodyText("No qualifications listed.")
            } else {
                addBulletList(job.qualifications)
            }
            
            addSectionHeader("Responsibilities")
            if job.responsibilities.isEmpty {
                addBodyText("No responsibilities listed.")
            } else {
                addBulletList(job.responsibilities)
            }
            
            addSectionHeader("Skills Required")
            if job.requirements.isEmpty {
                addBodyText("No skills listed.")
            } else {
                addBulletList(job.requirements)
            }
            
            addSectionHeader("Compensation")
            addBodyText("Salary Range: \(job.compensation.salaryRange.currency) \(job.compensation.salaryRange.min)-\(job.compensation.salaryRange.max)")
            if job.compensation.benefits.isEmpty {
                addBodyText("No benefits listed.")
            } else {
                addBodyText("Benefits: \(job.compensation.benefits.joined(separator: ", "))")
            }
            
        case 1:
            addSectionHeader("Skills & Experience Match")
            if job.requirements.isEmpty {
                addBodyText("No skills listed.")
            } else {
                addBulletList(job.requirements)
                addBodyText("These are the skills required for this role. You can highlight skill match percentage if available.")
            }
            
        case 2:
            addSectionHeader("About Company")
            addBodyText("Company: \(job.companyName)\nLocation: \(job.location.city), \(job.location.region), \(job.location.country)\nFor more info visit their website if available.")
            
        default:
            break
        }
    }
    
    private func addSectionHeader(_ text: String) {
        let headerLabel = UILabel()
        headerLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        headerLabel.textColor = .label
        headerLabel.numberOfLines = 0
        headerLabel.text = text
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.addArrangedSubview(headerLabel)
    }
    
    private func addBodyText(_ text: String) {
        let bodyLabel = UILabel()
        bodyLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        bodyLabel.textColor = .darkGray
        bodyLabel.numberOfLines = 0
        bodyLabel.text = text
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.addArrangedSubview(bodyLabel)
    }
    
    private func addBulletList(_ items: [String]) {
        for item in items {
            let bulletLabel = UILabel()
            bulletLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            bulletLabel.textColor = .darkGray
            bulletLabel.numberOfLines = 0
            bulletLabel.text = "• \(item)"
            bulletLabel.translatesAutoresizingMaskIntoConstraints = false
            contentStackView.addArrangedSubview(bulletLabel)
        }
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
}
