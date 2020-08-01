//
//  SqliteDatabaseManager.swift
//  CarTrackCodeChallenge
//
//  Created by WT-iOS on 1/8/20.
//  Copyright © 2020 vic. All rights reserved.
//

import Foundation
import SQLite
import RxSwift
import RxCocoa

protocol UserDatabaseManagerProtocol {
    static var shared: UserDatabaseManagerProtocol { get }
    func load()
    func checkLogin(userName: String, password: String) -> Swift.Result<(), DatabaseError>
    var dbStatus: Observable<Swift.Result<(db: Connection, table: Table), DatabaseError>?> { get }
}

enum DatabaseError: Error {
    case invalidPath(String?)
    case customError(Error)
    case loadFailure
    case readUserError
    case invalidUserNamePassword
    case duplicateUser // should not happen because username is unique. Added just for handling all cases
    
    var errorDescription: String {
        switch self {
        case .invalidPath(let path):
            return "Invalid Path \(path ?? String())"
        case .customError(let error):
            return "\((error as Error?).debugDescription)"
        case .loadFailure:
            return "Database load failure"
        case .readUserError:
            return "Unable to read database"
        case .invalidUserNamePassword:
            return "Invalid user name/ password"
        case .duplicateUser:
            return "Duplicate user found"
        }
    }
    
}

class SqliteDatabaseManager: UserDatabaseManagerProtocol {
    
    static var shared: UserDatabaseManagerProtocol { return sharedInstance }
    
    var dbStatus: Observable<Result<(db: Connection, table: Table), DatabaseError>?> {
        return dbLoadRelay.asObservable()
    }
    
    private static let sharedInstance =  SqliteDatabaseManager()
    private let dbLoadRelay = BehaviorRelay<Swift.Result<(db: Connection, table: Table), DatabaseError>?>(value: nil)
   
    private struct Constants {
        static let idKey = "id"
        static let userNameKey = "userNameKey"
        static let passwordKey = "passwordKey"
        static let defaultUsersPlistFileName = "DefaultUsers"
        static let dbFileName = "users.sqlite3"
        static let tableUserName = "users"
    }
    
    
    func load()  {
        dbLoadRelay.accept(loadTable())
    }
    
    func checkLogin(userName: String, password: String) -> Swift.Result<(), DatabaseError> {
        
        let usersDb: (db: Connection, table: Table)
        switch dbLoadRelay.value {
        case .success(let db):
            usersDb = db
        case .failure:
            return .failure(.loadFailure)
        case .none:
            return .failure(.loadFailure)
        }
        
        do {
            let userNameField = Expression<String>(Constants.userNameKey)
            let passwordField = Expression<String>(Constants.passwordKey)
            let query = usersDb.table
                .filter(userNameField == userName && passwordField == password )
                .limit(1)
            let rows = try usersDb.db.prepare(query)
            let results = Array(rows)
            
            if results.isEmpty {
                return .failure(.invalidUserNamePassword)
            } else if results.count > 1 {
                return .failure(.duplicateUser) // should not happen because username is unique. Added just for handling all cases
            } else {
                return .success(())
            }
        } catch  {
            return .failure(.readUserError)
        }
    }
    
    // MARK: - Private
    
    private func loadTable() -> Swift.Result<(db: Connection, table: Table), DatabaseError> {
        
        guard let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true).first else {
            return .failure(.invalidPath(NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true).first))
        }
        
        let db: Connection
        
        do {
            db = try Connection("\(path)/\(Constants.dbFileName)")
        } catch {
            return .failure(.customError(error))
        }

        let users = Table("\(Constants.tableUserName)")
        
        do {
            // check if table exists
            _ = try db.scalar(users.exists)
        } catch {
            let tableInitialization = initializeTable(connection: db, table: users)
            if case .failure = tableInitialization {
                return tableInitialization
            }
        }
        
        return .success((db, users))
    }
    
    private func initializeTable(connection: Connection, table: Table) -> Swift.Result<(db: Connection, table: Table), DatabaseError> {
        
        let id = Expression<Int64>(Constants.idKey)
        let userName = Expression<String>(Constants.userNameKey)
        let password = Expression<String>(Constants.passwordKey)
        
        do {
            try connection.run(table.create { t in
                t.column(id, primaryKey: true)
                t.column(userName, unique: true)
                t.column(password)
            })
        } catch  {
            return .failure(.customError(error))
        }
        
        
        let loadUsers = initialLoadUsers(connection: connection, table: table, userName: userName, password: password)
        
        return loadUsers
    }
    
    private func initialLoadUsers(connection: Connection,
                                  table: Table,
                                  userName: Expression<String>,
                                  password: Expression<String>) -> Swift.Result<(db: Connection, table: Table), DatabaseError> {
        
        struct DefaultUser: Codable {
            
            private enum CodingKeys : String, CodingKey {
                case userName = "userName"
                case password = "password"
            }
            
            let userName: String
            let password: String
        }
        
        guard let url = Bundle.main.url(forResource: Constants.defaultUsersPlistFileName, withExtension: "plist") else {
            
            return .failure(.invalidPath("Invalid Path \(Constants.defaultUsersPlistFileName) plist"))
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            let defaultUsers = try decoder.decode([DefaultUser].self, from: data)
            
            try defaultUsers.forEach {
                let insert = table.insert(userName <- $0.userName, password <- $0.password)

                try connection.run(insert)
            }
          } catch {
             return .failure(.customError(error))
          }
        
        return .success((connection, table))
    }
    
}
