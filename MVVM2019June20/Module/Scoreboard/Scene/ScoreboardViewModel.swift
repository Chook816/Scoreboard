//
//  ScoreboardViewModel.swift
//  MVVM2019June20
//
//  Created by Chook Yu Heng on 06/01/2021.
//  Copyright © 2021 Yee Chuan Lee. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ScoreboardViewModel: BaseViewModel, ScoreboardViewModelType {
    
    fileprivate typealias playerOneScore = (playerOneWinCounter: Int, winningRound: Int, winner: String)
    fileprivate typealias playerTwoScore = (playerTwoWinCounter: Int, winningRound: Int, winner: String)
    
    // MARK: Input
    let currentRound = BehaviorRelay<Int> (value: 1)
    let currentRoundText = BehaviorRelay<String?> (value: "Winner of Round 1")
    let playerOne = BehaviorRelay<String?> (value: nil)
    let playerTwo = BehaviorRelay<String?> (value: nil)
    let playerOneCounter = BehaviorRelay<Int> (value: 0)
    let playerTwoCounter = BehaviorRelay<Int> (value: 0)
    let winner = BehaviorRelay<String?> (value: nil)
    
    @ViewEvent var playerOneWinDidTapped: Driver<Void> = .never()
    @ViewEvent var playerTwoWinDidTapped: Driver<Void> = .never()
    
    // MARK: Output
    weak var view: ScoreboardViewType? = nil
    
    // MARK: Intent
    var intent: ScoreboardIntent
    
//    fileprivate var playerOneValue: playerOneScore {
//        return (playerOneWinCounter: playerOneCounter.value,
//                winningRound: winningRound.value,
//                winner: winner.value.orEmpty)
//    }
//
//    fileprivate var playerTwoValue: playerTwoScore {
//        return (playerTwoWinCounter: playerTwoCounter.value,
//                winningRound: winningRound.value,
//                winner: winner.value.orEmpty)
//    }
//
//    fileprivate var playerOneform: Driver<playerOneScore> {
//        return Driver.combineLatest([playerOneCounter.asDriver().distinctUntilChanged().asVoid(),
//                                     winningRound.asDriver().distinctUntilChanged().asVoid(),
//                                    winner.asDriver().distinctUntilChanged().asVoid()])
//            .map { _ in self.playerOneValue }
//    }
//
//    fileprivate var playerTwoform: Driver<playerTwoScore> {
//        return Driver.combineLatest([playerTwoCounter.asDriver().distinctUntilChanged().asVoid(),
//                                     winningRound.asDriver().distinctUntilChanged().asVoid(),
//                                    winner.asDriver().distinctUntilChanged().asVoid()])
//            .map { _ in self.playerTwoValue }
//    }
    
    // MARK: Initializer
    init(intent: ScoreboardIntent) {
        self.intent = intent
        self.playerOne.accept(intent.playerOne)
        self.playerTwo.accept(intent.playerTwo)
        
        super.init()
    }
    
    // MARK: Transform
    override func transform() {
        super.transform()
        
//        let playerOneWin = playerOneWinDidTapped
//            .withLatestFrom(playerOneform)
//            .flatMapLatest(self.updatePlayerOne)
//            .do(onNext: self.generateResult)
//        let playerTwoWin = playerTwoWinDidTapped
//            .withLatestFrom(playerTwoform)
//            .flatMapLatest(self.updatePlayerTwo)
//            .do(onNext: self.generateResult)
        let round = Driver.just(intent.round)
            .map { (round) -> Int in
                switch round {
                case "Best of One":
                    return 1
                case "Best of Three":
                    return 3
                case "Best of Five":
                    return 5
                default:
                    return 0
                }
            }
        let winningRound = round.filter{ $0 != 0 }.map { (round) -> Int in
            round % 2 + round/2
        }
        
        // convert to driver and then get latest form
        let currentRound = Driver.just(0)
        let playerOne = Driver.just(intent.playerOne)
        let playerTwo = Driver.just(intent.playerTwo)
        let playerOneWin = playerOneWinDidTapped
            .map { _ in
                var score = self.playerOneCounter.value
                score += 1
                self.playerOneCounter.accept(score)
            }
            .withLatestFrom(playerOne)
            .withLatestFrom(playerTwo) {( $0,$1 )}
            .do { (player1Name, player2Name) in
                let scoreDetails = ScoreDetails(playerOne: player1Name, playerTwo: player2Name, playerOneScore: self.playerOneCounter.value, playerTwoScore: self.playerTwoCounter.value)
                self.view?.rxUpdateWinRecord(scoreDetails: scoreDetails)
            }

        //subscribe
        disposeBag.insert(
            playerOneWin.drive()
//            playerTwoWin.drive()
        )
    }
    
    fileprivate func updatePlayerCounter(_ player:  BehaviorRelay<Int>) {
        var value = player.value
        value += 1
        player.accept(value)
    }
    
    fileprivate func updateMatchStatus() {
        var round = currentRound.value
        round += 1
        currentRound.accept(round)
        winner.value.isNilOrEmpty ? currentRoundText.accept("Winner of Round \(round)") : currentRoundText.accept("Match Ended")
    }
    
    fileprivate func updatePlayerOne(playerOneWinCounter: Int, winningRound: Int, winner: String) -> Driver<Void> {
        if playerOneWinCounter == winningRound - 1 && winner.isNilOrEmpty {
            self.winner.accept(playerOne.value)
            updatePlayerCounter(playerOneCounter)
        }else if winner.isNilOrEmpty {
            updatePlayerCounter(playerOneCounter)
        }
        updateMatchStatus()
        return .just(())
    }
    
    fileprivate func updatePlayerTwo(playerTwoWinCounter: Int, winningRound: Int, winner: String) -> Driver<Void> {
        if playerTwoWinCounter == winningRound - 1 && winner.isNilOrEmpty {
            self.winner.accept(playerTwo.value)
            updatePlayerCounter(playerTwoCounter)
        }else if winner.isNilOrEmpty {
            updatePlayerCounter(playerTwoCounter)
        }
        updateMatchStatus()
        return .just(())
    }

    fileprivate func generateResult() {
        if winner.value.isNilOrEmpty {
            self.view?.updateWinRecord()
        }else {
            self.view?.updateWinRecord()
            self.view?.routeToResult()
        }
    }

}
