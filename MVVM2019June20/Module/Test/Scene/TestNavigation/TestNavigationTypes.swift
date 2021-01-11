//
//  TestNavigationTypes.swift
//  MVVM2019June20
//
//  Created by Chook Yu Heng on 05/01/2021.
//  Copyright © 2021 Yee Chuan Lee. All rights reserved.
//

import Foundation

protocol TestNavigationViewType {
    var intent: TestNavigationIntent! { set get }
}

typealias TestNavigationControllerType = BaseNavigationController & TestNavigationViewType
