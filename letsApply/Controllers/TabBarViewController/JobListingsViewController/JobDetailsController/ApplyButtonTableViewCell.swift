//
//  ApplyButtonTableViewCell.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/12/13.
//

import Foundation
import UIKit

class ApplyButtonTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "ApplyButtonTableViewCellID"
    
    // MARK: - UI Elements
    
    let applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Apply Now", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemPink
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods
    
    private func setupUI() {
        contentView.addSubview(applyButton)
        
        NSLayoutConstraint.activate([
            applyButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            applyButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            applyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            applyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            applyButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
