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
    
    weak var delegate: JobDetailTableViewCellDelegate?
    
    
    lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Description", "Skills", "About Company"])
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var skillsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var aboutCompanyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var contentStackView: UIStackView = {
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
    
    
    func setupUI() {
        contentView.addSubview(segmentedControl)
        contentView.addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(descriptionLabel)
        contentStackView.addArrangedSubview(skillsLabel)
        contentStackView.addArrangedSubview(aboutCompanyLabel)
        
        segmentedControl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        
        contentStackView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16).isActive = true
        contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        
    }
    
    func configure(with job: Job) {
        descriptionLabel.text = job.description
        skillsLabel.text = "• " + job.requirements.joined(separator: "\n• ")
        aboutCompanyLabel.text = "Company: \(job.companyName)\nLocation: \(job.location.city), \(job.location.region), \(job.location.country)"
    }
    
    func updateContent(for index: Int) {
        descriptionLabel.isHidden = index != 0
        skillsLabel.isHidden = index != 1
        aboutCompanyLabel.isHidden = index != 2
    }
    
    @objc func segmentChanged() {
        updateContent(for: segmentedControl.selectedSegmentIndex)
        delegate?.didChangeSegment(to: segmentedControl.selectedSegmentIndex)
    }
}
