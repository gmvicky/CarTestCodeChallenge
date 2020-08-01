//
//  DocumentAndImageView.swift
//  Speshe
//
//  Created by WT-iOS on 2/4/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import UIKit
import PDFKit

class DocumentAndImageView: UIView, ViewCoderLoadable {
    
    @IBOutlet weak var pdfView: PDFView!
    @IBOutlet weak var pdfThumbnailView: PDFThumbnailView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewParent: UIView!
    @IBOutlet weak var pdfParentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpLoadableView()
        pdfThumbnailView.pdfView = pdfView
    }
    
    func setDocumentItem(_ item: DocumentImageWrapper) {
        
        let hiddenView: UIView
        let shownView: UIView
        
        switch item {
        case .image(let image):
            self.imageView.image = image
            hiddenView = pdfParentView
            shownView = imageViewParent
        case .document(let documents):
            guard let first = documents.first else { return }
            
            
            switch first.documentType {
            case .png, .jpg:
                self.pdfParentView.isHidden = true
                self.imageView.image = nil // R.image.uploadImage()
                self.imageView.util_setImage(source: .localUrl(first.url))
                hiddenView = pdfParentView
                shownView = imageViewParent
            case .pdf:
                hiddenView = imageViewParent
                shownView = pdfParentView
                if let document = PDFDocument(url: first.url) {
                    self.pdfView.document = document
                }
            }
        }
        hiddenView.isHidden = true
        shownView.isHidden = false
        
        
    }
}
