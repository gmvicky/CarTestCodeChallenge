//
//  LoginViewModelTests.swift
//  CarTrackCodeChallengeTests
//
//  Created by WT-iOS on 5/8/20.
//  Copyright © 2020 vic. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import CarTrackCodeChallenge

class LoginViewModelTests: XCTestCase {

    var viewModel: LoginViewModelProtocol?
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
    
    override func setUp() {
        super.setUp()
        let router = Router(viewController: nil)
        viewModel = LoginViewModel(router: router, databaseManager: SqliteDatabaseManager.shared)
    }
    
    func testCanProceedEmpty() {
        
        viewModel?.canProceed
            .subscribe(onNext: {
                XCTAssert($0 == false, "Should NOT be able to proceed")
            })
            .disposed(by: disposeBag)

    }

    func testCanProceedComplete() {
        
        viewModel?.userNameRelay.accept("1")
        viewModel?.passwordRelay.accept("1")

        if let country = CountryCodePickerViewController.Country(countryCode: "SG") {
            viewModel?.countryCodePickerViewControllerDidPickCountry(country)
        }
        
        viewModel?.canProceed
            .subscribe(onNext: {
                XCTAssert($0 == true, "Should be able to proceed")
            })
            .disposed(by: disposeBag)

    }
    
    func testCanProceedInvalidCountry() {
        
        let router = Router(viewController: nil)
        viewModel = LoginViewModel(router: router, databaseManager: SqliteDatabaseManager.shared)
        viewModel?.userNameRelay.accept("1")
        viewModel?.passwordRelay.accept("1")

        if let country = CountryCodePickerViewController.Country(countryCode: "###") {
            viewModel?.countryCodePickerViewControllerDidPickCountry(country)
        }
        
        viewModel?.canProceed
            .subscribe(onNext: {
                XCTAssert($0 == false, "Should NOT be able to proceed")
            })
            .disposed(by: disposeBag)

    }

}
