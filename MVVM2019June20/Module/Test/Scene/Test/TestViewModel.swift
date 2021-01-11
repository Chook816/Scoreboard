//
//  TestViewModel.swift
//  MVVM2019June20
//
//  Created by Chook Yu Heng on 05/01/2021.
//  Copyright © 2021 Yee Chuan Lee. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class TestViewModel: BaseViewModel, TestViewModelType {
    
    fileprivate typealias Players = (playerOne: String, playerTwo: String, round: String)
    
    // MARK: Input
    let playerOne = BehaviorRelay<String?> (value: nil)
    let playerTwo = BehaviorRelay<String?> (value: nil)
    let round = BehaviorRelay<String?> (value: "Best of One")
    let pickerDataSource = BehaviorRelay<[String]> (value: [])
    let enableButton = BehaviorRelay<Bool?> (value: false)
    
    @ViewEvent var playerOneScanDidTapped: Driver<Void> = .never()
    @ViewEvent var playerTwoScanDidTapped: Driver<Void> = .never()
    @ViewEvent var startGame: Driver<Void> = .never()
    
    // MARK: Output
    weak var view: TestViewType? = nil
    
    // MARK: Intent
    var intent: TestIntent
    
    fileprivate var formValue: Players {
        return (playerOne: playerOne.value.orEmpty,
                playerTwo: playerTwo.value.orEmpty,
                round: round.value.orEmpty)
    }
    fileprivate var form: Driver<Players> {
        return Driver.combineLatest([playerOne.asDriver().distinctUntilChanged().asVoid(),
                                     playerTwo.asDriver().distinctUntilChanged().asVoid(),
                                     round.asDriver().distinctUntilChanged().asVoid()])
            .map { _ in self.formValue }
    }
    
    // MARK: Initializer
    init(intent: TestIntent) {
        self.intent = intent
        super.init()
    }
    
    // MARK: Transform
    override func transform() {
        super.transform()
        
        let loadPicker = startLoad
            .flatMap(getPickerItems)
            .do(onNext: updatePickerItems)
        
        let routeToPlayerOneScan = playerOneScanDidTapped
            .do(onNext: { self.view?.routeToQRScannerOne()})
        let routeToPlayerTwoScan = playerTwoScanDidTapped
            .do(onNext: { self.view?.routeToQRScannerTwo()})
        let routeToScoreboard = startGame
            .do(onNext: { self.view?.routeToScoreboard()})
        let validation = form.asDriver().withLatestFrom(form).flatMapLatest(self.validate)
        
        //subscribe
        disposeBag.insert(
            loadPicker.drive(),
            routeToPlayerOneScan.drive(),
            routeToPlayerTwoScan.drive(),
            routeToScoreboard.drive(),
            validation.drive()
        )
    }
    
    fileprivate func updatePickerItems(items: [String]) {
        self.pickerDataSource.accept(items)
    }
    
    fileprivate func getPickerItems() -> Driver<[String]> {
        return Driver.just(["Best of One", "Best of Three", "Best of Five"])
//        return Observable.just(()).delay(.milliseconds(0), scheduler: MainScheduler.instance).map {
//            return (["Best of One", "Best of Three", "Best of Five"])
//        }
//        .trackActivity(activityIndicator)
//        .asDriverOnErrorJustSkip()
    }
    
    fileprivate func validate(playerOne: String, playerTwo: String, round: String) -> Driver<Void> {
        (playerOne.isNilOrEmpty || playerTwo.isNilOrEmpty || round.isNilOrEmpty) ? enableButton.accept(false) : enableButton.accept(true)
        // Return driver boolean here
        return .just(())
    }
    
}
