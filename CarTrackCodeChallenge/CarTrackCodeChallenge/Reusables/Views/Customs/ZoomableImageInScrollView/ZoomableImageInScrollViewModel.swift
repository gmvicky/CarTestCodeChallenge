//
//  ZoomableImageInScrollViewModel.swift
//  Speshe
//
//  Created by WT-iOS on 30/3/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import UIKit
import Combine
import RxSwift
import Action
import RxCocoa
import RxOptional

protocol ZoomableImageInScrollViewModelProtocol: BaseViewModelProtocol, ImagePickerAlertSourceViewModelProtocol  {
    
    var documentPicker: DocumentPickerViewModel { get }
    var documentImageWrapper: Observable<DocumentImageWrapper> { get }
    
    var onShowDocumentPicker: CocoaAction { get }
    var documentImageWrapperSubject: BehaviorRelay<DocumentImageWrapper?> { get }
}

enum DocumentImageWrapper {
    case image(UIImage)
    case document([DocumentItem])
    
    func data() -> Data? {
        switch self {
        case .image(let image):
            return image.pngData()
        case .document(let documents):
            guard let first = documents.first else { return nil }
            return first.data()
        }
    }
    
    func contentType() -> String {
        switch self {
        case .image:
            return "sample.png".mimeType()
        case .document(let documents):
            guard let first = documents.first?.mimeTypes().first else { return String() }
            return first
        }
    }
    
    func extensionName() -> String {
        switch self {
        case .image:
            return ".png"
        case .document(let documents):
            guard let first = documents.first,
                let extensionName = first.documentType.extensionFileNameComponent.first else { return String() }
            return extensionName
        }
    }
}

class ZoomableImageInScrollViewModel: BaseViewModel, ZoomableImageInScrollViewModelProtocol {

    lazy var documentPicker: DocumentPickerViewModel = {
        
        let picker = DocumentPickerViewModel()
        picker.rootViewController = router.viewController
        return picker
    }()
    
    // MARK: - ImagePickerAlertSourceViewModelProtocol
    
    lazy var onImageSelected: Action<UIImage, Void> = {
       return imageSelectedAction()
    }()
    
    let imageSelectedSubject = PublishSubject<UIImage>()
    
    lazy var onPresentImagePicker: CocoaAction = {
       return presentImagePickerAction()
    }()
    
    var viewControllerPresenter: UIViewController? {
        return router.viewController
    }
    
    let alertsSourceSubject = PublishSubject<AlertTagStructure>()
    let documentImageWrapperSubject = BehaviorRelay<DocumentImageWrapper?>(value: nil)
    
    var documentImageWrapper: Observable<DocumentImageWrapper> {
        return documentImageWrapperSubject
            .unwrap()
    }
    
    override func initialLoad() {
        
        imageSelectedSubject
            .map { .image($0) }
            .bind(to: documentImageWrapperSubject)
            .disposed(by: disposeBag)
        
        documentPicker.documentItemsSubject
            .filter { $0.isNotEmpty }
            .map { .document($0) }
            .bind(to: documentImageWrapperSubject)
            .disposed(by: disposeBag)
    }
    
    lazy var onShowDocumentPicker: CocoaAction = {
        return CocoaAction { [weak self] in
            self?.showDocumentPickerAlert()
            return .empty()
        }
    }()
    
    private func showDocumentPickerAlert() {
//        documentPicker.showDocumentPicker()
        guard let viewController = router.viewController else { return }
        
        var options = DocumentAndImagePickerAlert.alert(completion: sourceCompletion()) as [AlertOptionProtocol]
        options = options + [GenericAlertOption<()>.cancel(nil, nil)]
        
        let alertStructure = AlertTagStructure(title: "Select source", message: nil, style: .actionSheet, options: options)
        UIAlertController.present(in: viewController, alertStructure: alertStructure)
    }
    
    private func sourceCompletion() -> ((DocumentAndImagePickerAlert.DocumentSource) -> ()) {
        return { source in
            DispatchQueue.main.async { [weak self] in
                switch source {
                case .image(let imageSource):
                    self?.imagePickerClosure()(imageSource)
                case .document:
                    self?.documentPicker.showDocumentPicker()
                }
            }
        }
    }
    
}
