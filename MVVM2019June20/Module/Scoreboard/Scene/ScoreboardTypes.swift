//
//  ScoreboardTypes.swift
//  MVVM2019June20
//
//  Created by Chook Yu Heng on 06/01/2021.
//  Copyright © 2021 Yee Chuan Lee. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// create different protocol type for different scene
protocol ScoreboardViewType: BaseViewType {
    var intent: ScoreboardIntent! { set get }
    func updateWinRecord()
    func rxUpdateWinRecord(scoreDetails: ScoreDetails)
    func routeToResult()
}

typealias ScoreboardViewControllerType = UIViewController & ScoreboardViewType

protocol ScoreboardViewModelType {
    // MARK: -Input
//    var round: BehaviorRelay<Int?> { get }
    var currentRound: BehaviorRelay<Int> { get }
    var currentRoundText: BehaviorRelay<String?> { get }
//    var winningRound: BehaviorRelay<Int> { get }
    var playerOne: BehaviorRelay<String?> { get }
    var playerTwo: BehaviorRelay<String?> { get }
    var playerOneCounter: BehaviorRelay<Int> { get }
    var playerTwoCounter: BehaviorRelay<Int> { get }
    var winner: BehaviorRelay<String?> { get }
    
    var playerOneWinDidTapped: Driver<Void> { set get }
    var playerTwoWinDidTapped: Driver<Void> { set get }
    
    // MARK: -Output
    var view: ScoreboardViewType? { set get }
}
