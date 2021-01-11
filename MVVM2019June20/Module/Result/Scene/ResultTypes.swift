//
//  ResultTypes.swift
//  MVVM2019June20
//
//  Created by Chook Yu Heng on 07/01/2021.
//  Copyright © 2021 Yee Chuan Lee. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ResultViewType: BaseViewType {
    var intent: ResultIntent! { set get }
    func dismiss()
}

typealias ResultViewControllerType = UIViewController & ResultViewType

protocol ResultViewModelType {
    // MARK: -Input
    var backDidTapped: Driver<Void> { set get }
    
    // MARK: -Output
    var view: ResultViewType? { set get }
}

