//
//  UserDetailTableViewCell.swift
//  CarTrackCodeChallenge
//
//  Created by WT-iOS on 3/8/20.
//  Copyright © 2020 vic. All rights reserved.
//

import UIKit

class UserDetailTableViewCell: UITableViewCell, ViewReusable {
    
    static let preferredHeight = CGFloat(277.0)
    
    @IBOutlet weak var locationButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var catchPhraseLabel: UILabel!
    @IBOutlet weak var basicSystemLabel: UILabel!
    
    override func prepareForReuse() {
        addressLabel.text = nil
        super.prepareForReuse()
    }
}
