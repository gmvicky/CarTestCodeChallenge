//
//  ProfileImageAndNameView.swift
//  Speshe
//
//  Created by WT-iOS on 5/2/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import UIKit

protocol ProfileDataProtocol: class {
    var userName: String? { get }
    var email: String? { get }
    var imageSourceType: UIImageView.ImageSourceType? { get }
    var fullName: String? { get }
}

class ProfileImageAndNameView: UIView {
    
    enum NameDisplayType {
        case userName
        case fullName
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var nameDisplayType: NameDisplayType { return .userName }
    
    weak var profileData: ProfileDataProtocol? {
        didSet { setupProfileView() }
    }
    
    func setupProfileView() {
        nameLabel.text = nameDisplay()
        imageView.util_setImage(source: profileData?.imageSourceType)
    }
    
    // MARK: - Private
    
    private func nameDisplay() -> String? {
        guard let profileData = profileData else { return nil }
        switch nameDisplayType {
        case .userName: return profileData.userName
        case .fullName: return profileData.fullName
        }
    }
}
