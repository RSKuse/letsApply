//
//  JobInfoTableViewCell.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/12/13.
//

import Foundation
import UIKit

class JobInfoTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "JobInfoTableViewCellID"
    
    lazy var jobTypeChip: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.backgroundColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var locationChip: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.backgroundColor = .systemGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 16
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(jobTypeChip)
        stackView.addArrangedSubview(locationChip)
        
        
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        
        jobTypeChip.heightAnchor.constraint(equalToConstant: 30).isActive = true
        locationChip.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    func configure(with job: Job) {
        jobTypeChip.text = job.jobType
        locationChip.text = job.location.city
    }
}
