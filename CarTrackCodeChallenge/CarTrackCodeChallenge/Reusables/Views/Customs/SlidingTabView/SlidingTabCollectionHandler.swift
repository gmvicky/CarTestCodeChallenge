//
//  SlidingTabHeaderHandler.swift
//  Speshe
//
//  Created by WT-iOS on 27/2/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import UIKit

enum SlidingTabType {
    case header(SlidingTabStyle)
    case content
}

class SlidingTabCollectionHandler<T>: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var items = [T]()

    let slidingTabType: SlidingTabType
    weak var collectionView: UICollectionView?
    private var onDidSelect: ((Int, SlidingTabType) -> ())
    private var cellFactory: ((IndexPath, UICollectionView, SlidingTabType) -> (UICollectionViewCell))
    
    init(slidingTabType: SlidingTabType,
         onDidSelect: @escaping ((Int, SlidingTabType) -> ()),
         cellFactory: @escaping ((IndexPath, UICollectionView, SlidingTabType) -> (UICollectionViewCell))) {
        self.slidingTabType = slidingTabType
        self.onDidSelect = onDidSelect
        self.cellFactory = cellFactory
        super.init()
    }

    deinit {
        print("\(self.description) deinitialized")
    }
    
    func reloadItems(items: [T]) {
        self.items = items
        self.collectionView?.reloadData()
    }
    
    func configure(collectionView: UICollectionView?,
                   cellTypes: [ViewReusable.Type] = []) {
        self.collectionView = collectionView
        
        if case .content = slidingTabType {
            collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Constants.contentCellIdentifier)
        } else {
            collectionView?.register(views: cellTypes)
        }
        collectionView?.delegate = self
        collectionView?.dataSource = self
    }
     
    // MARK: - UICollectionViewDelegate
       func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if case .header = slidingTabType {
                onDidSelect(indexPath.item, slidingTabType)
            }
            
       }
       
       func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            if case .content = slidingTabType {
                let currentIndex = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
                onDidSelect(currentIndex, slidingTabType)
            }
       }
       
       // MARK: - UICollectionViewDataSource
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return items.count
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            if case .content = slidingTabType {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.contentCellIdentifier, for: indexPath)
                let itemRaw = items[indexPath.row]
                guard let vc = itemRaw as? UIViewController else { return cell }
                cell.addSubview(vc.view)
               
                vc.view.translatesAutoresizingMaskIntoConstraints = false
                vc.view.topAnchor.constraint(equalTo: cell.topAnchor, constant: 0).isActive = true
                vc.view.leadingAnchor.constraint(equalTo: cell.leadingAnchor).isActive = true
                vc.view.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
                vc.view.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
               
                return cell
            } else {
                return cellFactory(indexPath, collectionView, slidingTabType)
            }
            
       }
       
       // MARK: - UICollectionViewDelegateFlowLayout
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
           if case .header(let tabStyle) = slidingTabType {
               if tabStyle == .fixed {
                   let spacer = CGFloat(items.count)
                   var offset = CGFloat.zero
                   if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
                       offset = layout.sectionInset.left + layout.sectionInset.right
                   }
                   return CGSize(width: (collectionView.frame.width - offset) / spacer, height: collectionView.frame.height)
            } else {
                guard let title = items[indexPath.row] as? String else { return .zero }

                   let stringSize = title.sizeOfString(usingFont: Constants.font)
                   return CGSize(width: stringSize.width + Constants.widthOffset, height: collectionView.frame.height)
               }
           }
           return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           
           return 0
       }
}



fileprivate struct Constants {
    static let font = UIFont.systemFont(ofSize: 13, weight: .semibold)
    static let widthOffset = CGFloat(60.0)
    static let indicatorBottomOffset = CGFloat(0)
    static let contentCellIdentifier = "contentCellIdentifier"
}
