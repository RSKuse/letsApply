//
//  JobHeaderTableViewCell.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/12/13.
//

import Foundation
import UIKit

class JobHeaderTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "JobHeaderTableViewCellID"
    
    // MARK: - UI Elements
    
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
    
    private let salaryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(white: 1.0, alpha: 0.85)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        applyGradient()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods
    
    private func setupUI() {
        contentView.addSubview(jobTitleLabel)
        contentView.addSubview(companyNameLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(salaryLabel)
        
        NSLayoutConstraint.activate([
            jobTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            jobTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            jobTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            companyNameLabel.topAnchor.constraint(equalTo: jobTitleLabel.bottomAnchor, constant: 8),
            companyNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            companyNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            locationLabel.topAnchor.constraint(equalTo: companyNameLabel.bottomAnchor, constant: 4),
            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            salaryLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 4),
            salaryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            salaryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            salaryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func applyGradient() {
        // Apply gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.systemPink.cgColor,
            UIColor.systemPurple.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = contentView.bounds
        contentView.layer.insertSublayer(gradientLayer, at: 0)
        
        // Ensure the gradient resizes with the cell
//        gradientLayer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    // MARK: - Configuration
    
    func configure(with job: Job) {
        jobTitleLabel.text = job.title
        companyNameLabel.text = job.companyName
        let locationParts = [job.location.city, job.location.region, job.location.country].filter { !$0.isEmpty }
        locationLabel.text = locationParts.joined(separator: ", ")
        salaryLabel.text = "Salary: \(job.compensation.salaryRange.currency) \(job.compensation.salaryRange.min)-\(job.compensation.salaryRange.max)"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let gradientLayer = contentView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = contentView.bounds
        }
    }
}
