//
//  JobCollectionViewCell.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/12/05.
//

import Foundation
import UIKit

class JobCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "JobCollectionViewCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .systemPurple
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var companyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var salaryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        // Use accent color for salary
        label.textColor = .systemPink
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        // Make bookmark color more subtle, systemGray
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.tintColor = .systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var deadlineLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var experienceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var requirementsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        // Softer background and subtle shadow for elegance
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.05
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 6
        
        // Add subviews
        contentView.addSubview(titleLabel)
        contentView.addSubview(companyLabel)
        contentView.addSubview(salaryLabel)
        contentView.addSubview(bookmarkButton)
        contentView.addSubview(deadlineLabel)
        contentView.addSubview(experienceLabel)
        contentView.addSubview(requirementsLabel)
        contentView.addSubview(locationLabel)

        // Set up constraints
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        
        bookmarkButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        bookmarkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        
        companyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        companyLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        companyLabel.trailingAnchor.constraint(lessThanOrEqualTo: bookmarkButton.leadingAnchor, constant: -8).isActive = true
        
        salaryLabel.topAnchor.constraint(equalTo: companyLabel.bottomAnchor, constant: 8).isActive = true
        salaryLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        salaryLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16).isActive = true
        
        deadlineLabel.topAnchor.constraint(equalTo: salaryLabel.bottomAnchor, constant: 8).isActive = true
        deadlineLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        deadlineLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16).isActive = true
        
        experienceLabel.topAnchor.constraint(equalTo: deadlineLabel.bottomAnchor, constant: 8).isActive = true
        experienceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        experienceLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16).isActive = true
        
        requirementsLabel.topAnchor.constraint(equalTo: experienceLabel.bottomAnchor, constant: 8).isActive = true
        requirementsLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        requirementsLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16).isActive = true
        
        locationLabel.topAnchor.constraint(equalTo: requirementsLabel.bottomAnchor, constant: 8).isActive = true
        locationLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        locationLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16).isActive = true
        // Location at the bottom ensures cell grows as needed
        locationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
    }
    
    func configure(with job: Job) {
        titleLabel.text = job.title
        companyLabel.text = job.companyName
        salaryLabel.text = "Salary: \(job.compensation.salaryRange.currency) \(job.compensation.salaryRange.min)-\(job.compensation.salaryRange.max)"
        deadlineLabel.text = "Deadline: \(job.application.deadline)"
        experienceLabel.text = "Experience: \(job.experience.minYears)-\(job.experience.preferredYears) years"
        requirementsLabel.text = "Requirements: " + (job.requirements.isEmpty ? "N/A" : job.requirements.joined(separator: ", "))
        locationLabel.text = "\(job.location.city), \(job.location.region), \(job.location.country)"
    }
}
