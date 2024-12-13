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
    
    lazy var applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Apply Now", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemPink
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubview(applyButton)
        
        applyButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        applyButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24).isActive = true
        applyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24).isActive = true
        applyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
        applyButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
    }
}
