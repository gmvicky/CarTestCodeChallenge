//
//  NetworkRequest.swift
//  InstantMac
//
//  Created by Paul Sevilla on 20/05/2018.
//  Copyright © 2018 Monstar Lab Pte Ltd. All rights reserved.
//

import RxSwift
import Moya
import ObjectMapper
import SwiftyJSON


let WebServiceDidReturnTokenErrorNotificationName = Foundation.Notification.Name( "WebServiceDidReturnTokenError")

protocol WebServiceType {
    associatedtype Provider
    
    func requestJSON(path: Provider) -> Observable<JSON>
    func requestObject<T: Codable>(path: Provider) -> Observable<T>
    func requestCollection<T: Codable>(path: Provider) -> Observable<[T]>
}

struct WebService<U: TargetType>: WebServiceType {
    private let provider: MoyaProvider<U>
    
    init(provider: MoyaProvider<U> = MoyaProvider<U>()) {
        self.provider = provider
    }
    
    // MARK: - Internal Methods
    
    func requestJSON(path: U) -> Observable<JSON> {
        return request(path: path)
            .map { JSON($0.data)  }
    }
    
    func requestObject<T: Codable>(path: U) -> Observable<T> {
        return request(path: path)
            .map {
                do {
                    return try $0.map(T.self)
                } catch {
                    throw WebServiceError.mapping
                }
        }
    }
    
    func requestCollection<T: Codable>(path: U) -> Observable<[T]> {
        return request(path: path)
            .map {
                do {
                    return try $0.map([T].self)
                } catch {
                    throw WebServiceError.mapping
                }
        }
    }
    
    // MARK: - Private Methods
    private let disposeBag = DisposeBag()
    
    private func request(path: U) -> Observable<Response> {
        
        print("path : \(path.baseURL)\(path.path)")
        print("BODY : \(path.task)")
        print("USE HEADERS: \(String(describing: path.headers))")
        
        return Observable.create { observer in
          let request = self.provider.request(path, completion: { result in
            switch result {
            case let .success(response):
              if 200..<300 ~= response.statusCode  {
                print("\(path.path) : \((try? response.mapJSON()) ?? "")")
                observer.onNext(response)
                observer.onCompleted()
              } else {
                let error = self.error(from: response)
                observer.onError(error)
                print("Request failed: [\(path.method.rawValue.uppercased()) \(path.path)] \(error.errorDescription ?? (try? response.mapString()) ?? "Unknown Error")")
              }
            case let .failure(error):
              observer.onError(WebServiceError.moya(error: error))
              print("Request failed: [\(path)] \(error.localizedDescription)")
                
            }
          })
          return Disposables.create {
            request.cancel()
          }
        }
        
    }
    
    
    private func error(from response: Response) -> WebServiceError {
        do {
            let object = try response.map(ErrorResponse.self)
            var messages = [object.status?.message].compactMap { $0 }
            let customMessages = object.data
            
            if let message = object.message {
               messages.insert(message, at: 0)
            }
            
            if let errorData = object.data {
                for (_, value) in errorData {
                    if let errorsString = value as? [String] {
                        messages.append(contentsOf: errorsString)
                    }
                }
            }
            
            return WebServiceError.api(code: object.status?.statusCode ?? -1, messages: messages, customMessages: customMessages)
        } catch {
            return WebServiceError.mapping
        }
    }
    
    private func hasTokenRelatedError(response: Response) -> Bool {
        if let responseArray = try? response.mapJSON() as? [String], let value = responseArray.first {
            let tokenErrors = ["user_not_found", "token_expired", "token_invalid", "token_absent"]
            return tokenErrors.contains(value)
        }
        return false
    }
}
