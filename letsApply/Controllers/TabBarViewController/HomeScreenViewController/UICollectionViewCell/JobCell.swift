//
//  JobCell.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/12/16.
//

import Foundation
import UIKit

class JobCell: UICollectionViewCell {
    static let reuseIdentifier = "JobCell"
    
    private lazy var jobTitleLabel: UILabel = {
           let label = UILabel()
           label.font = UIFont.boldSystemFont(ofSize: 16)
           label.numberOfLines = 2
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
       
       private lazy var companyLabel: UILabel = {
           let label = UILabel()
           label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
           label.textColor = .secondaryLabel
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
       
       private lazy var locationLabel: UILabel = {
           let label = UILabel()
           label.font = UIFont.systemFont(ofSize: 13)
           label.textColor = .systemGray
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
       
       private lazy var containerView: UIView = {
           let view = UIView()
           view.backgroundColor = .secondarySystemBackground
           view.layer.cornerRadius = 8
           view.translatesAutoresizingMaskIntoConstraints = false
           return view
       }()
       
       // MARK: - Initializer
       
       override init(frame: CGRect) {
           super.init(frame: frame)
           setupUI()
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
       // MARK: - Configuration
       
       func configure(with job: Job) {
           jobTitleLabel.text = job.title
           companyLabel.text = job.companyName
           locationLabel.text = "\(job.location.city), \(job.location.country)"
       }
       
       // MARK: - Setup UI
       
       private func setupUI() {
           contentView.addSubview(containerView)
           containerView.addSubview(jobTitleLabel)
           containerView.addSubview(companyLabel)
           containerView.addSubview(locationLabel)
           
           NSLayoutConstraint.activate([
               containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
               containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
               containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
               containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
               
               jobTitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
               jobTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
               jobTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
               
               companyLabel.topAnchor.constraint(equalTo: jobTitleLabel.bottomAnchor, constant: 5),
               companyLabel.leadingAnchor.constraint(equalTo: jobTitleLabel.leadingAnchor),
               companyLabel.trailingAnchor.constraint(equalTo: jobTitleLabel.trailingAnchor),
               
               locationLabel.topAnchor.constraint(equalTo: companyLabel.bottomAnchor, constant: 5),
               locationLabel.leadingAnchor.constraint(equalTo: companyLabel.leadingAnchor),
               locationLabel.trailingAnchor.constraint(equalTo: companyLabel.trailingAnchor),
               locationLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -10)
           ])
       }
   }
