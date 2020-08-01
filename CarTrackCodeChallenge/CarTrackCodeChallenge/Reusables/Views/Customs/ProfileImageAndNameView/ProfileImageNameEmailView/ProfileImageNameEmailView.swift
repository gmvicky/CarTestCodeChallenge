//
//  ProfileImageNameEmailView.swift
//  Speshe
//
//  Created by WT-iOS on 5/2/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import UIKit

class ProfileImageNameEmailView: ProfileImageAndNameView, ViewCoderLoadable {
    
    @IBOutlet weak var emailLabel: UILabel!
    
    override var nameDisplayType: ProfileImageAndNameView.NameDisplayType { return .fullName }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpLoadableView()
    }
    
    override func setupProfileView() {
        super.setupProfileView()
        emailLabel.text = profileData?.email
    }
}
