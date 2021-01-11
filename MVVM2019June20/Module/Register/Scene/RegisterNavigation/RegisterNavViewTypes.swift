//
//  RegisterNavViewTypes.swift
//  MVVM2019June20
//
//  Created by lee yee chuan on 01/03/2020.
//  Copyright © 2020 Yee Chuan Lee. All rights reserved.
//

import Foundation
import UIKit

protocol RegisterNavigationViewType {
    var intent: RegisterNavigationIntent! { set get }
}

typealias RegisterNavigationControllerType = BaseNavigationController & RegisterNavigationViewType
