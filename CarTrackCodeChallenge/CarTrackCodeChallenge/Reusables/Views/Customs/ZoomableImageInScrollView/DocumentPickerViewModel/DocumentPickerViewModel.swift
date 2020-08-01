//
//  UIDocumentPickerViewModel.swift
//  xApp
//
//  Created by WT-iOS on 11/12/19.
//  Copyright © 2019 WorkTable. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import MobileCoreServices


class DocumentPickerViewModel: NSObject {
    
    weak var rootViewController: UIViewController?
    
    let documentItemsSubject = BehaviorRelay(value: [DocumentItem]())
    
    func showDocumentPicker() {
        
        let fileBrowser = UIDocumentPickerViewController(documentTypes: [(kUTTypePDF as String), (kUTTypeJPEG as String), (kUTTypePNG as String)], in: .import)
        fileBrowser.delegate = self
        fileBrowser.modalPresentationStyle = .formSheet
        rootViewController?.present(fileBrowser, animated: true, completion: nil)
    }
}

extension DocumentPickerViewModel: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        documentItemsSubject.accept(urls.compactMap { DocumentType.documentItem(forUrl: $0 )})
    }
}

enum DocumentType: Int, CaseIterable, Codable {
    case png
    case jpg
    case pdf
    
    var extensionFileName: [String] {
        switch self {
        case .png: return ["png"]
        case .jpg: return ["jpg", "jpeg"]
        case .pdf: return ["pdf"]
        }
    }
    
    var extensionFileNameComponent: [String] {
        switch self {
        case .png: return [".png"]
        case .jpg: return [".jpg", ".jpeg"]
        case .pdf: return [".pdf"]
        }
    }
    
    static func documentItem(forUrl url: URL) -> DocumentItem? {
        let extensionFileName = url.pathExtension
        
        let documentType = DocumentType.allCases.first(where: { $0.extensionFileName.contains(extensionFileName )})
        guard let aDocumentType = documentType else { return nil }
        return DocumentItem(documentType: aDocumentType, url: url)
    }
}

struct DocumentItem: Codable {
    
    let documentType: DocumentType
    let url: URL
    
    func data() -> Data? {
        return try? Data(contentsOf: url)
    }
    
    func mimeTypes() -> [String] {
        return documentType.extensionFileName.map { $0.mimeType() }
    }
}
