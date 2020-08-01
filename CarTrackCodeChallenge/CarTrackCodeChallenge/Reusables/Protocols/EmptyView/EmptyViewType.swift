//
//  EmptyViewType.swift
//  InstantMac
//
//  Created by Harold on 27/04/2018.
//  Copyright © 2018 Monstar Lab Pte Ltd. All rights reserved.
//

import UIKit
import Action

protocol EmptyViewLoadable: ViewCoderLoadable { }

protocol EmptyViewType {
    func view() -> UIView & EmptyViewLoadable
}
