//
//  JobDetailTableViewCell.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/12/13.
//

import Foundation
import UIKit

protocol JobDetailTableViewCellDelegate: AnyObject {
    func didChangeSegment(to index: Int)
}

class JobDetailTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "JobDetailTableViewCellID"
    
    // MARK: - Delegate
    
    weak var delegate: JobDetailTableViewCellDelegate?
    
    // MARK: - UI Elements
    
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Description", "Skills", "About Company"])
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let skillsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let aboutCompanyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        updateContent(for: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods
    
    private func setupUI() {
        contentView.addSubview(segmentedControl)
        contentView.addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(descriptionLabel)
        contentStackView.addArrangedSubview(skillsLabel)
        contentStackView.addArrangedSubview(aboutCompanyLabel)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            segmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            contentStackView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with job: Job) {
        descriptionLabel.text = job.description
        skillsLabel.text = "• " + job.requirements.joined(separator: "\n• ")
        aboutCompanyLabel.text = "Company: \(job.companyName)\nLocation: \(job.location.city), \(job.location.region), \(job.location.country)"
    }
    
    private func updateContent(for index: Int) {
        descriptionLabel.isHidden = index != 0
        skillsLabel.isHidden = index != 1
        aboutCompanyLabel.isHidden = index != 2
    }
    
    // MARK: - Actions
    
    @objc private func segmentChanged() {
        updateContent(for: segmentedControl.selectedSegmentIndex)
        delegate?.didChangeSegment(to: segmentedControl.selectedSegmentIndex)
    }
}
