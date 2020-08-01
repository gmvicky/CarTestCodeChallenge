//
//  UIViewController+ImagePickerPresenter.swift
//  FrontRow
//
//  Created by WT-iOS on 6/9/19.
//  Copyright © 2019 WT-iOS. All rights reserved.
//

import Foundation
import UIKit
import Photos

extension UIImagePickerController {
    typealias Presenter = UIViewController & UIImagePickerControllerDelegate & UINavigationControllerDelegate
}

extension UIImagePickerControllerDelegate where Self: UIImagePickerController.Presenter {
    
    func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        
        switch sourceType {
        case .camera:
            RequestCameraHelper.requestAccessAndProcess(viewController: self) { [weak self] in
                self?.instantiatePicker(sourceType: sourceType)
            }
        case .photoLibrary, .savedPhotosAlbum:
            PhotosHelper.requestAccessAndProcess(viewController: self) { [weak self] in
                self?.instantiatePicker(sourceType: sourceType)
            }
        }
    }
    
    private func instantiatePicker(sourceType: UIImagePickerController.SourceType) {
        DispatchQueue.main.async { [weak self] in
             if UIImagePickerController.isSourceTypeAvailable(sourceType) {
                 let imagePickerController = UIImagePickerController()
                 imagePickerController.delegate = self
                 imagePickerController.sourceType = sourceType
                 self?.present(imagePickerController, animated: true, completion: nil)
             }
        }
        
    }
}

struct RequestCameraHelper {
    
    static func requestAccessAndProcess(viewController: UIViewController?, completion: @escaping (() -> ())) {
        
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                completion()
            } else {
                showAlert(viewController: viewController)
            }
        }
    }
    
    private static func showAlert(viewController: UIViewController?) {
        
        DispatchQueue.main.async  {
            let alertController = UIAlertController(title: "Oops !!!", message: "Please grant access to camera", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: {
                (action : UIAlertAction!) -> Void in
                PhoneAppSettingsHelper.displaySettings()
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (action : UIAlertAction!) -> Void in
            })
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            viewController?.present(alertController, animated: true, completion: nil)
        }
    }
}

struct PhotosHelper {
    static func requestAccessAndProcess(viewController: UIViewController?, completion: @escaping (() -> ())) {
        
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
       switch photoAuthorizationStatus {
       case .authorized:
           print("Access is granted by user")
           completion()
       case .notDetermined:
           PHPhotoLibrary.requestAuthorization({
               (newStatus) in
               print("status is \(newStatus)")
               if newStatus ==  PHAuthorizationStatus.authorized {
                   /* do stuff here */
                   print("success")
                   completion()
                   
               }
           })
           print("It is not determined until now")
       case .restricted:
           // same same
           print("User do not have access to photo album.")
        showAlert(viewController: viewController)
       case .denied:
           // same same
           print("User has denied the permission.")
        showAlert(viewController: viewController)
       @unknown default:
           print("Unknown")
       }
    }
    
    private static func showAlert(viewController: UIViewController?) {
        
        DispatchQueue.main.async {
             let alertController = UIAlertController(title: "Oops !!!", message: "Please grant access to photos", preferredStyle: .alert)
             let okAction = UIAlertAction(title: "Ok", style: .default, handler: {
                 (action : UIAlertAction!) -> Void in
                 PhoneAppSettingsHelper.displaySettings()
             })
             let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                 (action : UIAlertAction!) -> Void in
             })
             alertController.addAction(okAction)
             alertController.addAction(cancelAction)
             viewController?.present(alertController, animated: true, completion: nil)
        }
        
    }
}
