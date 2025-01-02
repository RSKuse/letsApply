//
//  MetricCell.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/12/17.
//

import UIKit

class MetricCardCell: UICollectionViewCell {
    // Reuse Identifier
    static let reuseIdentifier = "MetricCardCell"
    
    // Title Label
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Value Label
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Card Background View
    private let cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Background Gradient
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemPink.cgColor, UIColor.systemPurple.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = bounds
        cardView.layer.insertSublayer(gradient, at: 0)
        
        // Add Card View
        contentView.addSubview(cardView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(valueLabel)
        
        // Constraints
        
        cardView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        valueLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
        valueLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor, constant: -5).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 4).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
        
    }
    
    func configure(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }
}
