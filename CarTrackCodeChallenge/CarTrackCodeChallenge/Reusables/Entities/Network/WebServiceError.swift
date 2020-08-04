//
//  WebServiceError.swift
//  InstantMac
//
//  Created by Paul Sevilla on 22/05/2018.
//  Copyright © 2018 Monstar Lab Pte Ltd. All rights reserved.
//

import Foundation
import Moya

enum WebServiceError: Error {
  case api(code: Int, messages: [String], customMessages: [String: Any]?)
  case firebase(code: Int, message: String)
  case moya(error: MoyaError)
  case mapping
}

extension WebServiceError: LocalizedError {
  var errorCode: Int {
    switch self {
    case let .api(code, _, _):
      return code
    case let .moya(moyaError):
      return moyaError.response?.statusCode ?? -10000
    case let .firebase(code, _):
      return code
    case .mapping:
      return -10001
    }
  }
  
  var errorMessages: [String] {
    switch self {
    case let .api(_, messages, _):
      return messages
    case let .firebase(_, message):
      return [message]
    default:
      return []
    }
  }
  
  var errorDescription: String? {
    switch self {
    case let .api(_, messages, _):
      return messages.joined(separator: " ")
    case let .firebase(_, message):
      return message
    case let .moya(error):
      return error.localizedDescription
    default:
      return nil
    }
  }
  
}
