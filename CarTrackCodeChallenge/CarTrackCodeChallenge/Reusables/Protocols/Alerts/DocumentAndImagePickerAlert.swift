//
//  DocumentAndImagePickerAlert.swift
//  Speshe
//
//  Created by WT-iOS on 1/4/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import Foundation
import UIKit

struct DocumentAndImagePickerAlert: AlertOptionProtocol {
    
    enum DocumentSource {
        case image(UIImagePickerController.SourceType)
        case document
    }
    
    var pickerType: DocumentSource
    var pickerTypeClosure: ((DocumentSource)->())
    
    var title: String? {
        switch pickerType {
        case .image(let sourceType):
            switch sourceType {
                case .photoLibrary: return "Photo Library"
               case .camera: return "Camera"
               case .savedPhotosAlbum: return "Album"
               @unknown default: return nil
            }
        case .document:
            return "Document"
        }
    }
    
    var style: UIAlertAction.Style {
        return .default
    }
    
    func customAction() {
        pickerTypeClosure(pickerType)
    }
}

extension DocumentAndImagePickerAlert {
    
    static func alert(completion: @escaping ((DocumentSource)->())) -> [DocumentAndImagePickerAlert] {
        
        return [DocumentAndImagePickerAlert(pickerType: .image(.photoLibrary), pickerTypeClosure: completion),
         DocumentAndImagePickerAlert(pickerType: .image(.savedPhotosAlbum), pickerTypeClosure: completion),
        DocumentAndImagePickerAlert(pickerType: .image(.camera), pickerTypeClosure: completion),
        DocumentAndImagePickerAlert(pickerType: .document, pickerTypeClosure: completion)]
    }
}
