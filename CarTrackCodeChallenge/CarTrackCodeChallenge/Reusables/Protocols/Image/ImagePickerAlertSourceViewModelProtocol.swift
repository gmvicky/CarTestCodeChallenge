//
//  ImagePickerAlertSourceViewModelProtocol.swift
//  FrontRow
//
//  Created by WT-iOS on 18/10/19.
//  Copyright © 2019 WT-iOS. All rights reserved.
//

import Foundation
import RxSwift
import UIKit
import Action
import AVFoundation

protocol ImagePickerAlertSourceViewModelProtocol: class, AlertSourceViewModelProtocol {
    
    var onImageSelected: Action<UIImage, Void> { get }
    var imageSelectedSubject: PublishSubject<UIImage> { get }
    var onPresentImagePicker: CocoaAction { get }
    var viewControllerPresenter: UIViewController? { get }
}

extension ImagePickerAlertSourceViewModelProtocol {
    
    func imageSelectedAction() -> Action<UIImage, Void> {
        return Action { [weak self] image in
            DispatchQueue.global(qos: .background).async { [weak self] in
                let resized = image.resize(withMaximumDimension: 1024)
                DispatchQueue.main.async { [weak self] in
                    self?.imageSelectedSubject.onNext(resized)
                }
            }
            
            return .empty()
        }
    }
    
    func imagePickerAlert() -> AlertTagStructure {
        
        let options: [AlertOptionProtocol] =
            [ImagePickerAlert(imagePickerType: .photoLibrary, imagePickerTypeClosure: imagePickerClosure()),
             ImagePickerAlert(imagePickerType: .camera, imagePickerTypeClosure: imagePickerClosure()),
             ImagePickerAlert(imagePickerType: .savedPhotosAlbum, imagePickerTypeClosure: imagePickerClosure()),
             GenericAlertOption<()>.cancel(nil, nil)]
        
        return AlertTagStructure(style: .actionSheet, tintColor: nil, options: options)
    }
    
    func presentImagePicker(in viewController: UIViewController) {
        let alert = imagePickerAlert()
        UIAlertController.present(in: viewController, alertStructure: alert)
    }
    
    func presentImagePickerAction() -> CocoaAction {
        return CocoaAction { [weak self] in
            guard let parentVC = self?.viewControllerPresenter else { return .empty() }
            self?.presentImagePicker(in: parentVC)
            return .empty()
        }
    }
    
    func imagePickerClosure() -> ((UIImagePickerController.SourceType) -> ()) {
        return { [weak self] pickerType in
            DispatchQueue.main.async { [weak self] in
                if let presenter = self?.viewControllerPresenter as? UIImagePickerController.Presenter {
                    presenter.presentImagePicker(sourceType: pickerType)
                    
                }
            }
            
        }
    }
    
//    private func permission(type: AVMediaType) {
//        if AVCaptureDevice.authorizationStatus(for: .) ==  .authorized {
//            //already authorized
//        } else {
//            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
//                if granted {
//                    //access allowed
//                } else {
//                    //access denied
//                }
//            })
//        }
//    }
}
