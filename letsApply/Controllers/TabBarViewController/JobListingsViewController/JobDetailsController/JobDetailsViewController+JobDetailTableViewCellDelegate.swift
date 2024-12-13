//
//  JobDetailsViewController+JobDetailTableViewCellDelegate.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/12/13.
//

import Foundation
import UIKit

extension JobDetailsViewController: JobDetailTableViewCellDelegate {
    func didChangeSegment(to index: Int) {
        // Reload the details section to update content
        let detailsSection = JobDetailSection.details.rawValue
        tableView.reloadSections(IndexSet(integer: detailsSection), with: .automatic)
    }
}
