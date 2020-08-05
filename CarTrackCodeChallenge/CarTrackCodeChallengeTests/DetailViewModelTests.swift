//
//  DetailViewModelTests.swift
//  CarTrackCodeChallengeTests
//
//  Created by WT-iOS on 5/8/20.
//  Copyright © 2020 vic. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
import RxTest
@testable import CarTrackCodeChallenge

class DetailViewModelTests: XCTestCase {

    var detailViewModel: DetailViewModel?
    let disposeBag = DisposeBag()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testFetch() {
        let router = Router(viewController: nil)
        detailViewModel = DetailViewModel(router: router)
        
        let promise = expectation(description: "Users fetched")
        detailViewModel?.initialLoad()
        
        detailViewModel?
            .sectionModels?
            .skip(1)
            .take(1)
            .subscribe(onNext: {
                if $0.isNotEmpty {
                    promise.fulfill()
                } else {
                    XCTFail("Error: No users fetched")
                }
            }, onError: {  XCTFail("Error: \($0.localizedDescription)") })
            .disposed(by: disposeBag)
        
         wait(for: [promise], timeout: 5)
            
    }
}
