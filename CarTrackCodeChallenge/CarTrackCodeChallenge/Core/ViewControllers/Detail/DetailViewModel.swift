//
//  DetailViewModel.swift
//  CarTrackCodeChallenge
//
//  Created by WT-iOS on 2/8/20.
//  Copyright © 2020 vic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action
import RxDataSources
import SkeletonView
import MapKit

protocol DetailViewModelProtocol: BaseViewModelProtocol, TableViewConfigurator {
    
}

class DetailViewModel: BaseViewModel, DetailViewModelProtocol {
    
    var tableViewDataSource: RxTableViewSectionedAnimatedDataSource<DetailSectionModel>?
    var collectionDisposeBag = DisposeBag()
    
    private var tableUIHandler: TableViewHandlerIdentifiableItems<DetailSectionModel>?
    private let sectionsRelay = BehaviorRelay(value: [DetailSectionModel]())
    private let webService: DetailWebServiceProtocol
    
    init(router: RouterProtocol,
         webService: DetailWebServiceProtocol = DetailWebService()) {
        self.webService = webService
        super.init(router: router)
    }
    
    override func initialLoad() {
        sectionsRelay.accept(DetailSectionModel.skeletonItems())

        onFetchUsers.execute()
    }
    
    func configureTableView(_ tableView: UITableView) {
        tableUIHandler = TableViewHandlerIdentifiableItems(tableView: tableView)
        tableUIHandler?.delegate  = self
        loadTable(tableView)
    }
    
    // MARK: - Private
    
    private lazy var onFetchUsers: CocoaAction = {
        return CocoaAction { [weak self] in
            guard let `self` = self else { return .empty() }
            return self.fetchUsers()
        }
    }()
    
    private lazy var onUserDetailAction: Action<(UserDetail, UserDetailAction), Void> = {
        return Action { [weak self] (userDetail, action) in

            switch action {
            case .map:
                guard let address = userDetail.address else { return .empty() }
                let destination = MainScene.map(address).router()
                self?.router.open(destination, transition: ModalTransition())
            }
            
            return .empty()
        }
    }()
    
    private func fetchUsers() -> Observable<()> {
        
        let subject = PublishSubject<()>()
        
        let parameters = ["limit": 2, "count": 2, "page": 2] as [String: Any]
        
        let request = webService.users(parameters: parameters)
            .take(1)
            .materialize()
            .share(replay: 1)
        
        request
            .errors()
            .subscribe(onNext: { _ in
                subject.onCompleted()
            })
            .disposed(by: disposeBag)
        
        request
            .elements()
            .subscribe(onNext: { [weak self] in
                
                var currentItems = self?.sectionsRelay.value.first?.items ?? []
                if currentItems.first?.isSkeleton ?? false {
                    currentItems = $0.map { DetailItemModel(userDetail: $0, onUserDetailAction: self?.onUserDetailAction) }
                } else {
                    let items = $0.filter { newItem in
                        !currentItems.contains(where: { $0.identity == newItem.id })
                    }.map { DetailItemModel(userDetail: $0, onUserDetailAction: self?.onUserDetailAction) }
                    currentItems.append(contentsOf: items)
                }
                self?.sectionsRelay.accept([DetailSectionModel(items: currentItems, identity: 0)])
                subject.onCompleted()
            })
            .disposed(by: disposeBag)
            
        return subject
    }
}


extension DetailViewModel : TableViewControllerRxAnimatedDatasources {
    
    var sectionModels: Observable<[DetailSectionModel]>? {
        return sectionsRelay.asObservable()
    }
    
    var cellConfiguration: ((TableViewSectionedDataSource<DetailSectionModel>, UITableView, IndexPath, DetailSectionModel.Item) -> UITableViewCell)? {
        return { (sectionModel, tableView, indexPath , item) in
            
            let cell: UserDetailTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            
            cell.locationButton.rx.bind(to: item.onCustomUserAction, input: .map)
            
            cell.addressLabel.text = item.userDetail.address?.formattedAddress
            cell.addressLabel.updateConstraintsIfNeeded()
            DispatchQueue.main.async {
                cell.addressLabel.text = item.userDetail.address?.formattedAddress
                cell.nameLabel.text = item.userDetail.name
                cell.userNameLabel.text = item.userDetail.username
                cell.emailLabel.text = item.userDetail.email
                cell.phoneLabel.text = item.userDetail.phone
                cell.websiteLabel.text = item.userDetail.website
                cell.companyNameLabel.text = item.userDetail.company?.name
                cell.catchPhraseLabel.text = item.userDetail.company?.catchPhrase
                cell.basicSystemLabel.text = item.userDetail.company?.basicSystem?.firstUppercased
                cell.layoutIfNeeded()
                cell.setNeedsLayout()
            }
            
            if item.isSkeleton {
                cell.showAnimatedGradientSkeleton()
            } else {
                cell.hideSkeleton()
            }
            
            return cell
        }
    }
    
    var cellTypes: [ViewReusable.Type] {
        return [UserDetailTableViewCell.self]
    }
    
}


extension DetailViewModel: TableViewHandlerDelegate {
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= (sectionsRelay.value.first?.items ?? []).count - 1
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            onFetchUsers.execute()
        }
    }
}
