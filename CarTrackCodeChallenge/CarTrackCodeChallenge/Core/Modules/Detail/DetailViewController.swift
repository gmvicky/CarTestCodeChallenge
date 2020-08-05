//
//  DetailViewController.swift
//  CarTrackCodeChallenge
//
//  Created by WT-iOS on 2/8/20.
//  Copyright © 2020 vic. All rights reserved.
//

import UIKit

class DetailViewController: BaseViewController<DetailViewModel> {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func configureViews() {
        setupNavigationItemLeftBarButtonImage()
        tableView.estimatedRowHeight = UserDetailTableViewCell.preferredHeight
    }
    
    override func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.configureTableView(tableView)
    }
}
