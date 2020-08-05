//
//  SqliteDatabaseManagerTests.swift
//  CarTrackCodeChallengeTests
//
//  Created by WT-iOS on 5/8/20.
//  Copyright © 2020 vic. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import CarTrackCodeChallenge

class SqliteDatabaseManagerTests: XCTestCase {

    
    
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
    
    func testLoadDb() {
        deleteDb()
        
        var isLoadedCorrectly = true
        let users:[[String: Any]]? = {
            guard let url = Bundle.main.url(forResource: "DefaultUsers", withExtension: "plist")  else { return nil }
            return NSArray(contentsOf: url) as? [[String: Any]]
        }()
        
        SqliteDatabaseManager.shared.load()
        
        if users == nil { isLoadedCorrectly = false }
        
        let fetchedUsers = users ?? []
        
        for user in fetchedUsers {
            if let userName = user["userName"] as? String,
                let password = user["password"] as? String {
                _ = SqliteDatabaseManager.shared.checkLogin(userName: userName, password: password)
            } else {
                isLoadedCorrectly = false
            }
            
            if !isLoadedCorrectly {
                break
            }
        }
        
        XCTAssert(isLoadedCorrectly == true, "Db not loaded correctly")
    }
    
    
    func deleteDb() {
        guard let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true).first  else { return }
        try? FileManager.default.removeItem(at: URL(fileURLWithPath: path).appendingPathComponent("users.sqlite3"))
    }
}
