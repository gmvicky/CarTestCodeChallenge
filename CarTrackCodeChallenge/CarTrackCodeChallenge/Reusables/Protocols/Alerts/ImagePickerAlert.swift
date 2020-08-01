//
//  ImagePickerAlert.swift
//  FrontRow
//
//  Created by WT-iOS on 9/9/19.
//  Copyright © 2019 WT-iOS. All rights reserved.
//

import Foundation
import UIKit

struct ImagePickerAlert: AlertOptionProtocol {
    
    var imagePickerType: UIImagePickerController.SourceType
    var imagePickerTypeClosure: ((UIImagePickerController.SourceType)->())
    
    var title: String? {
        switch imagePickerType {
        case .photoLibrary: return "Photo Library"
        case .camera: return "Camera"
        case .savedPhotosAlbum: return "Album"
        @unknown default: return nil
        }
    }
    
    var style: UIAlertAction.Style {
        return .default
    }
    
    func customAction() {
        imagePickerTypeClosure(imagePickerType)
    }
}
