//
//  JobTableViewCell.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/25.
//

import Foundation
import UIKit

class JobTableViewCell: UITableViewCell {

    // UI Elements
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var companyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var saveJobButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var applyNowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Apply Now", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // Configure Cell
    func configure(with job: Job) {
        titleLabel.text = job.title
        companyLabel.text = job.companyName
        locationLabel.text = job.location
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(companyLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(saveJobButton)
        contentView.addSubview(applyNowButton)

        // Constraints
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true

        companyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        companyLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true

        locationLabel.topAnchor.constraint(equalTo: companyLabel.bottomAnchor, constant: 5).isActive = true
        locationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        locationLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true

        saveJobButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        saveJobButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true

        applyNowButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        applyNowButton.rightAnchor.constraint(equalTo: saveJobButton.leftAnchor, constant: -10).isActive = true
    }
}
