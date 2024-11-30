//
//  JobListingsViewController+TableView.swift
//  letsApply
//
//  Created by Gugulethu Mhlanga on 2024/11/30.
//

import Foundation
import UIKit

extension JobListingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.jobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: JobTableViewCell.identifier, for: indexPath) as? JobTableViewCell else {
            return UITableViewCell()
        }
        let job = viewModel.jobs[indexPath.row]
        cell.configure(with: job)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let job = viewModel.jobs[indexPath.row]
        let jobDetailsVC = JobDetailsViewController(job: job)
        navigationController?.pushViewController(jobDetailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
