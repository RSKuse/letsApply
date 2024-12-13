//
//  JobDetailsViewController+TableView.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/12/13.
//

import Foundation
import UIKit

extension JobDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    enum JobDetailSection: Int, CaseIterable {
        case header
        case info
        case details
        case apply
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return JobDetailSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = JobDetailSection(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch section {
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: JobHeaderTableViewCell.reuseIdentifier, for: indexPath) as! JobHeaderTableViewCell
            cell.configure(with: job)
            return cell
        case .info:
            let cell = tableView.dequeueReusableCell(withIdentifier: JobInfoTableViewCell.reuseIdentifier, for: indexPath) as! JobInfoTableViewCell
            cell.configure(with: job)
            return cell
        case .details:
            let cell = tableView.dequeueReusableCell(withIdentifier: JobDetailTableViewCell.reuseIdentifier, for: indexPath) as! JobDetailTableViewCell
            cell.configure(with: job)
            return cell
        case .apply:
            let cell = tableView.dequeueReusableCell(withIdentifier: ApplyButtonTableViewCell.reuseIdentifier, for: indexPath) as! ApplyButtonTableViewCell
            cell.applyButton.addTarget(self, action: #selector(applyForJob), for: .touchUpInside)
            return cell
        }
    }

    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        guard let jobSection = JobDetailSection(rawValue: indexPath.section) else {
//            return UITableViewCell()
//        }
//        
//        switch jobSection {
//        case .header:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: JobHeaderTableViewCell.identifier, for: indexPath) as? JobHeaderTableViewCell else {
//                return UITableViewCell()
//            }
//            cell.configure(with: job)
//            cell.selectionStyle = .none
//            return cell
//            
//        case .info:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: JobInfoTableViewCell.identifier, for: indexPath) as? JobInfoTableViewCell else {
//                return UITableViewCell()
//            }
//            cell.configure(with: job)
//            cell.selectionStyle = .none
//            return cell
//            
//        case .details:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: JobDetailTableViewCell.identifier, for: indexPath) as? JobDetailTableViewCell else {
//                return UITableViewCell()
//            }
//            cell.delegate = self
//            cell.configure(with: job)
//            cell.selectionStyle = .none
//            return cell
//            
//        case .apply:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: ApplyButtonTableViewCell.identifier, for: indexPath) as? ApplyButtonTableViewCell else {
//                return UITableViewCell()
//            }
//            cell.applyButton.addTarget(self, action: #selector(applyForJob), for: .touchUpInside)
//            cell.selectionStyle = .none
//            return cell
//        }
//    }
    
    // Optional: Section Headers
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
}
