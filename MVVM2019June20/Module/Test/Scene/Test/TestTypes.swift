//
//  TestViewTypes.swift
//  MVVM2019June20
//
//  Created by Chook Yu Heng on 05/01/2021.
//  Copyright © 2021 Yee Chuan Lee. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol TestViewType: BaseViewType {
    var intent: TestIntent! { set get }
    func routeToQRScannerOne()
    func routeToQRScannerTwo()
    func routeToScoreboard()
}

typealias TestViewControllerType = UIViewController & TestViewType

protocol TestViewModelType {
    // MARK: -Input
    var playerOne: BehaviorRelay<String?> { get }
    var playerTwo: BehaviorRelay<String?> { get }
    var round: BehaviorRelay<String?> { get }
    
    var startGame: Driver<Void> { set get }
    var playerOneScanDidTapped: Driver<Void> { set get }
    var playerTwoScanDidTapped: Driver<Void> { set get }
    
    // MARK: -Output
    var view: TestViewType? { set get }
}
