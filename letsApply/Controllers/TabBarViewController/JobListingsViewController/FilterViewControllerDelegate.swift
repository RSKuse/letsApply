//
//  FilterViewControllerDelegate.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/12/11.
//

import Foundation

protocol FilterViewControllerDelegate: AnyObject {
    func didApplyFilters(_ filters: JobFilters)
}
