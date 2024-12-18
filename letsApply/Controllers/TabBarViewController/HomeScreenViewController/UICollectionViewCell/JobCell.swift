//
//  JobCell.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/12/16.
//

import UIKit

class JobCell: UICollectionViewCell {
    static let reuseidentifier = "JobCell"
    
    private let jobTitleLabel = UILabel()
    private let companyLabel = UILabel()
    private let locationLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        jobTitleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        companyLabel.font = UIFont.systemFont(ofSize: 14)
        locationLabel.font = UIFont.systemFont(ofSize: 12)
        locationLabel.textColor = .gray
        
        let stackView = UIStackView(arrangedSubviews: [jobTitleLabel, companyLabel, locationLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = UIColor.systemGray6
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with job: Job) {
        jobTitleLabel.text = job.title
        companyLabel.text = job.companyName
        locationLabel.text = "\(job.location.city), \(job.location.country)"
    }
}
