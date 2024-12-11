//
//  JobFiltersViewController.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/25.
//

import UIKit

class FilterViewController: UIViewController {
    weak var delegate: FilterViewControllerDelegate?

    
    private let skillsTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter skills (comma separated)"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let locationTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter location"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let jobTypeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter job type"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // Apply Button
    private let applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Apply Filters", for: .normal)
        button.backgroundColor = .systemPink
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(applyFilters), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Filters"
        view.backgroundColor = .systemBackground
        setupUI()
        
        // Add Cancel button
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissSelf))
    }
    
    private func setupUI() {
        view.addSubview(skillsTextField)
        view.addSubview(locationTextField)
        view.addSubview(jobTypeTextField)
        view.addSubview(applyButton)
        
        
        skillsTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        skillsTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        skillsTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        skillsTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        locationTextField.topAnchor.constraint(equalTo: skillsTextField.bottomAnchor, constant: 20).isActive = true
        locationTextField.leadingAnchor.constraint(equalTo: skillsTextField.leadingAnchor).isActive = true
        locationTextField.trailingAnchor.constraint(equalTo: skillsTextField.trailingAnchor).isActive = true
        locationTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        jobTypeTextField.topAnchor.constraint(equalTo: locationTextField.bottomAnchor, constant: 20).isActive = true
        jobTypeTextField.leadingAnchor.constraint(equalTo: skillsTextField.leadingAnchor).isActive = true
        jobTypeTextField.trailingAnchor.constraint(equalTo: skillsTextField.trailingAnchor).isActive = true
        jobTypeTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        applyButton.topAnchor.constraint(equalTo: jobTypeTextField.bottomAnchor, constant: 40).isActive = true
        applyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        applyButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        applyButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
         
    }
    
    @objc private func applyFilters() {
        let skillsInput = skillsTextField.text?.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) } ?? []
        let locationInput = locationTextField.text ?? ""
        let jobTypeInput = jobTypeTextField.text ?? ""
        
        let filters = JobFilters(skills: skillsInput, location: locationInput, jobType: jobTypeInput)
        delegate?.didApplyFilters(filters)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
}
